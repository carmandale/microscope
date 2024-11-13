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
    let cancerCellPrefix = "CancerCells_"
    let healthyCellPrefix = "HealthyCells_"
    let cancerModelName = "CancerCell"
    let healthyModelName = "HealthyCell"
    
    var body: some View {
        RealityView { content in
            guard let scene = try? await Entity(named: "Scene", in: realityKitContentBundle) else {
                print("❌ Failed to load scene")
                return
            }
            print("✅ Successfully loaded scene")
            
            // Load both cell models
            guard let cancerCellModel = try? await Entity(named: cancerModelName, in: realityKitContentBundle) else {
                print("❌ Failed to load cancer cell model: \(cancerModelName)")
                return
            }
            print("✅ Successfully loaded cancer cell model")
            
            guard let healthyCellModel = try? await Entity(named: healthyModelName, in: realityKitContentBundle) else {
                print("❌ Failed to load healthy cell model: \(healthyModelName)")
                return
            }
            print("✅ Successfully loaded healthy cell model")
            
            // Find the blood vessel entity
            guard let bloodVessel = scene.findEntity(named: "bloodVessel_v004") else {
                print("❌ Could not find blood vessel entity")
                return
            }
            print("✅ Found blood vessel entity")
            
            // Get the world transform of the blood vessel
            let bloodVesselTransform = bloodVessel.transform
            print("🔄 Blood vessel transform: \(bloodVesselTransform)")
            
            // Find and process both cell types
            let cancerTransforms = bloodVessel.findAllTransforms(containing: cancerCellPrefix)
            let healthyTransforms = bloodVessel.findAllTransforms(containing: healthyCellPrefix)
            
            print("🔍 Found \(cancerTransforms.count) cancer cells and \(healthyTransforms.count) healthy cells")
            
            // Place cancer cells
            for (index, transform) in cancerTransforms.enumerated() {
                // Create debug sphere (red for cancer)
                let sphere = createDebugSphere(color: .red)
                
                // Clone and setup cancer cell
                let cellInstance = cancerCellModel.clone(recursive: true)
                print("📏 Cancer cell \(index + 1) original scale: \(cellInstance.scale)")
                
                // Add cell component
                cellInstance.components[CellComponent.self] = CellComponent(type: .cancer)
                
                // Position both entities
                let worldTransform = transform.convert(transform: .init(), to: scene)
                sphere.transform = worldTransform
                cellInstance.transform = worldTransform
                
                // Add to scene
                scene.addChild(sphere)
                scene.addChild(cellInstance)
                
                print("📍 Placed cancer cell \(index + 1) at \(worldTransform.translation)")
            }
            
            // Place healthy cells
            for (index, transform) in healthyTransforms.enumerated() {
                // Create debug sphere (green for healthy)
                let sphere = createDebugSphere(color: .green)
                
                // Clone and setup healthy cell
                let cellInstance = healthyCellModel.clone(recursive: true)
                print("📏 Healthy cell \(index + 1) original scale: \(cellInstance.scale)")
                
                // Add cell component
                cellInstance.components[CellComponent.self] = CellComponent(type: .healthy)
                
                // Position both entities
                let worldTransform = transform.convert(transform: .init(), to: scene)
                sphere.transform = worldTransform
                cellInstance.transform = worldTransform
                
                // Add to scene
                scene.addChild(sphere)
                scene.addChild(cellInstance)
                
                print("📍 Placed healthy cell \(index + 1) at \(worldTransform.translation)")
            }
            
            content.add(scene)
            print("✅ Added scene to content with \(cancerTransforms.count) cancer cells and \(healthyTransforms.count) healthy cells")
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
}

extension Entity {
    func findAllTransforms(containing namePrefix: String) -> [Entity] {
        var transforms: [Entity] = []
        
        if self.name.contains(namePrefix) {
            transforms.append(self)
            print("🎯 Found transform '\(self.name)'")
        }
        
        for child in children {
            transforms.append(contentsOf: child.findAllTransforms(containing: namePrefix))
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


