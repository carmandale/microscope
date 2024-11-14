//
//  AttackCancer.swift
//  Microscope
//
//  Created by Dale Carman on 11/13/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct AttackCancerView: View {
    @State private var contentEntity: Entity?
    @State private var targetedEntity: Entity?
    
    let cancerCellPrefix = "CancerCells_"
    let healthyCellPrefix = "HealthyCells_"
    let cancerModelName = "CancerCell"
    let healthyModelName = "HealthyCell"
    let adcModelName = "ADC"
    
    private class ADCPool {
        private var availableADCs: [Entity] = []
        private var activeADCs: Set<Entity> = []
        private static let poolSize = 20
        
        func initialize(with template: Entity) {
            guard availableADCs.isEmpty else { return }
            for _ in 0..<Self.poolSize {
                let clone = template.clone(recursive: true)
                clone.isEnabled = false
                availableADCs.append(clone)
            }
        }
        
        func obtain() -> Entity? {
            guard let adc = availableADCs.popLast() else { return nil }
            adc.isEnabled = true
            activeADCs.insert(adc)
            return adc
        }
        
        func recycle(_ adc: Entity) {
            guard activeADCs.contains(adc) else { return }
            adc.isEnabled = false
            activeADCs.remove(adc)
            availableADCs.append(adc)
        }
    }
    
    private static let adcPool = ADCPool()
    
    // Move static properties to a separate class
    private class ADCState {
        static var cachedADCModel: Entity?
        static var lastShotTime: TimeInterval = 0
        static let minimumShotInterval: TimeInterval = 0.1
    }
    
    var body: some View {
        RealityView { content in
            // Load all required models in parallel
            async let sceneTask = Entity(named: "Scene", in: realityKitContentBundle)
            async let cancerModelTask = Entity(named: cancerModelName, in: realityKitContentBundle)
            async let healthyModelTask = Entity(named: healthyModelName, in: realityKitContentBundle)
            
            guard let scene = try? await sceneTask,
                  let cancerCellModel = try? await cancerModelTask,
                  let healthyCellModel = try? await healthyModelTask,
                  let bloodVessel = scene.findEntity(named: "bloodVessel_v004") else {
                print("❌ Failed to load required models")
                return
            }
            
            contentEntity = scene
            content.add(scene)
            
            // Pre-fetch all transforms once
            let cancerTransforms = bloodVessel.findAllTransforms(containing: cancerCellPrefix)
            let healthyTransforms = bloodVessel.findAllTransforms(containing: healthyCellPrefix)
            
            // Create cells in batches
            await withTaskGroup(of: Void.self) { group in
                let batchSize = 10

                // Process cancer cells
                for batch in stride(from: 0, to: cancerTransforms.count, by: batchSize) {
                    let endIndex = min(batch + batchSize, cancerTransforms.count)
                    let batchTransforms = Array(cancerTransforms[batch..<endIndex])
                    group.addTask {
                        await self.processBatch(batchTransforms, model: cancerCellModel, type: .cancer, color: .red, in: scene)
                    }
                }

                // Process healthy cells
                for batch in stride(from: 0, to: healthyTransforms.count, by: batchSize) {
                    let endIndex = min(batch + batchSize, healthyTransforms.count)
                    let batchTransforms = Array(healthyTransforms[batch..<endIndex])
                    group.addTask {
                        await self.processBatch(batchTransforms, model: healthyCellModel, type: .healthy, color: .green, in: scene)
                    }
                }
            }

        } update: { content in
            // Handle updates if needed
        }
        .gesture(TapGesture().onEnded { _ in
            handleShoot()
        })
    }
    
    private func handleTargeting(_ entity: Entity) {
        // Only target cancer cells
        guard let cellComponent = entity.components[CellComponent.self],
              cellComponent.type == .cancer else {
            targetedEntity = nil
            return
        }
        
        targetedEntity = entity
        
        // Simplest visual feedback for now
        if var modelComponent = entity.components[ModelComponent.self] {
            modelComponent.materials = [SimpleMaterial(color: .red, isMetallic: true)]
            entity.components[ModelComponent.self] = modelComponent
        }
    }
    
    private func handleShoot() {
        guard let target = targetedEntity,
              let scene = contentEntity,
              let camera = scene.findEntity(named: "Camera") else { return }
        
        let shootPosition = camera.position + SIMD3<Float>(0, -0.3, 0)
        shootADC(from: shootPosition, target: target)
    }
    
    private func shootADC(from location: SIMD3<Float>, target: Entity) {
        guard let scene = contentEntity else { return }
        
        Task {
            let currentTime = CACurrentMediaTime()
            guard currentTime - ADCState.lastShotTime >= ADCState.minimumShotInterval else { return }
            ADCState.lastShotTime = currentTime
            
            // Initialize pool if needed
            if ADCState.cachedADCModel == nil {
                ADCState.cachedADCModel = try? await Entity(named: adcModelName, in: realityKitContentBundle)
                if let template = ADCState.cachedADCModel {
                    Self.adcPool.initialize(with: template)
                }
            }
            
            await MainActor.run {
                guard let adc = Self.adcPool.obtain() else { return }
                
                // Calculate proper Z depth based on camera position
                if let camera = scene.findEntity(named: "Camera") {
                    let cameraZ = camera.position.z
                    let targetZ = cameraZ - 2.0  // Place ADC 2 units in front of camera
                    adc.position = SIMD3<Float>(location.x, location.y, targetZ)
                } else {
                    adc.position = location
                }
                
                let initialVelocity = SIMD3<Float>(0, -0.5, -1.0) * 2.0
                adc.components[ADCComponent.self] = ADCComponent(
                    velocity: initialVelocity,
                    isActive: true
                )
                
                scene.addChild(adc)
                
                // Recycle after 5 seconds
                Task {
                    try? await Task.sleep(for: .seconds(5))
                    await MainActor.run {
                        adc.removeFromParent()
                        Self.adcPool.recycle(adc)
                    }
                }
            }
        }
    }
    
    private func createDebugSphere(color: UIColor) -> ModelEntity {
        ModelEntity(
            mesh: .generateSphere(radius: 0.2),
            materials: [SimpleMaterial(
                color: color,
                isMetallic: true
            )]
        )
    }
    
    // Move processBatch outside of the withTaskGroup block
    private func processBatch(_ transforms: [Entity], model: Entity, type: CellType, color: UIColor, in scene: Entity) async {
        for transform in transforms {
            let cellInstance = model.clone(recursive: true)
            cellInstance.components[CellComponent.self] = CellComponent(type: type)
            
            let worldTransform = transform.convert(transform: .init(), to: scene)
            cellInstance.transform = worldTransform
            
            #if DEBUG
            let sphere = createDebugSphere(color: color)
            sphere.transform = worldTransform
            await MainActor.run { scene.addChild(sphere) }
            #endif
            
            cellInstance.components[MovableEntityComponent.self] = MovableEntityComponent(
                position: worldTransform.translation
            )
            
            await MainActor.run { scene.addChild(cellInstance) }
        }
    }
}

extension Entity {
    func findAllTransforms(containing namePrefix: String) -> [Entity] {
        // Use a more efficient search algorithm
        var transforms: [Entity] = []
        let queue = Queue<Entity>()
        queue.enqueue(self)
        
        while let current = queue.dequeue() {
            if current.name.contains(namePrefix) {
                transforms.append(current)
            }
            
            current.children.forEach { queue.enqueue($0) }
        }
        
        return transforms
    }
    
    func findEntity(named name: String) -> Entity? {
        if self.name == name {
            return self
        }
        
        for child in children {
            if let found = child.findEntity(named: name) {
                return found
            }
        }
        
        return nil
    }
}

extension float4x4 {
    var translation: SIMD3<Float> {
        SIMD3<Float>(columns.3.x, columns.3.y, columns.3.z)
    }
}

// Helper Queue implementation for breadth-first search
private class Queue<T> {
    private var elements: [T] = []
    
    func enqueue(_ element: T) {
        elements.append(element)
    }
    
    func dequeue() -> T? {
        guard !elements.isEmpty else { return nil }
        return elements.removeFirst()
    }
}
