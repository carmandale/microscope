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
    let transformPrefix = "CancerCells_"
    let modelName = "CancerCell"  // The name of your cancer cell model
    
    var body: some View {
        RealityView { content in
            guard let scene = try? await Entity(named: "Scene", in: realityKitContentBundle) else {
                print("❌ Failed to load scene")
                return
            }
            print("✅ Successfully loaded scene")
            
            // Load the cancer cell model
            guard let cancerCellModel = try? await Entity(named: modelName, in: realityKitContentBundle) else {
                print("❌ Failed to load cancer cell model: \(modelName)")
                if let entityURLs = realityKitContentBundle.urls(forResourcesWithExtension: "usdz", subdirectory: nil) {
                    print("📋 Available models in bundle:")
                    entityURLs.forEach { print("- \($0.lastPathComponent)") }
                }
                return
            }
            print("✅ Successfully loaded cancer cell model")
            
            // First, find the blood vessel entity
            guard let bloodVessel = scene.findEntity(named: "bloodVessel_v004") else {
                print("❌ Could not find blood vessel entity")
                return
            }
            print("✅ Found blood vessel entity")
            
            // Get the world transform of the blood vessel
            let bloodVesselTransform = bloodVessel.transform
            print("🔄 Blood vessel transform: \(bloodVesselTransform)")
            
            // Find all transforms containing "CancerCells"
            let transforms = bloodVessel.findAllTransforms(containing: transformPrefix)
            print("🔍 Found \(transforms.count) transforms containing '\(transformPrefix)'")
            
            for (index, transform) in transforms.enumerated() {
                // Create debug sphere
                let sphere = ModelEntity(
                    mesh: .generateSphere(radius: 0.2),
                    materials: [SimpleMaterial(
                        color: .red,
                        isMetallic: true
                    )]
                )
                
                // Clone the cancer cell model
                let cellInstance = cancerCellModel.clone(recursive: true)
                cellInstance.scale = [1.0, 1.0, 1.0]
                
                // Get the world transform
                let worldTransform = transform.convert(transform: .init(), to: scene)
                
                // Position both the sphere and cell
                var sphereTransform = worldTransform
                sphereTransform.scale = [1.0, 1.0, 1.0] // Keep sphere scale constant
                sphere.transform = sphereTransform
                
                var cellTransform = worldTransform
                cellTransform.scale = cellInstance.scale
                cellInstance.transform = cellTransform
                
                print("📍 Transform \(index + 1) '\(transform.name)'")
                print("  Local position: \(transform.position)")
                print("  World position: \(worldTransform.translation)")
                print("  Cell scale: \(cellInstance.scale)")
                
                // Add both to the scene
                scene.addChild(sphere)
                scene.addChild(cellInstance)
            }
            
            content.add(scene)
            print("✅ Added scene to content with \(transforms.count) pairs of spheres and cancer cells")
        }
        .installGestures()
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


