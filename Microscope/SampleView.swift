//
//  SampleView.swift
//  Microscope
//
//  Created by Dale Carman on 11/4/24.
//


import SwiftUI
import RealityKit

struct SampleView: View {
    @State private var cancellables = [EventSubscription]()
    
    var body: some View {
        HStack {
            // 2D Window Content
            VStack {
                Text("VisionOS Sample View")
                    .font(.title)
                    .padding()
                
                Image(systemName: "vision.pro")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .padding()
            }
            .padding()
            .frame(width: 400)
            
            // 3D Content
            RealityView { content in
                // Create cylinder
                let cylinder = ModelEntity(
                    mesh: .generateCylinder(height: 0.2, radius: 0.1),
                    materials: [SimpleMaterial(color: .blue, isMetallic: true)]
                )
                
                // Initial 45° Z rotation
                let zRotation = simd_quatf(angle: .pi / 4, axis: SIMD3<Float>(0, 0, 1))
                cylinder.transform = Transform(rotation: zRotation)
                
                // Add cylinder to content
                content.add(cylinder)
                
                // Subscribe to update events for continuous rotation
                let rotationEvent = content.subscribe(to: SceneEvents.Update.self) { event in
                    let deltaTime = Float(event.deltaTime)
                    let yRotation = simd_quatf(
                        angle: deltaTime,
                        axis: SIMD3<Float>(0, 1, 0)
                    )
                    // Combine rotations using matrix multiplication
                    cylinder.transform.rotation = yRotation * cylinder.transform.rotation
                }
                
                // Store subscription
                cancellables.append(rotationEvent)
            }
            .frame(width: 400, height: 400)
        }
    }
}

#Preview {
    SampleView()
} 