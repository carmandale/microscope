//
//  ImmersiveView.swift
//  Microscope
//
//  Created by Dale Carman on 10/31/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ImmersiveView: View {
    
    @State private var contentEntity: Entity?
    
    var body: some View {
        RealityView { content in
            // Add the initial RealityKit content
            if let immersiveContentEntity = try? await Entity(named: "Immersive", in: realityKitContentBundle) {
                contentEntity = immersiveContentEntity
                content.add(contentEntity!)
                
                
                
                // Put skybox here.  See example in World project available at
                // https://developer.apple.com/
            }
            
        }
        .installGestures()
        .gesture (TapGesture().targetedToAnyEntity()
            .onEnded({ value in
                // Apply the tap behavior on the entity
                _ = value.entity.applyTapForBehaviors()
            })
        )
    }
}

    
