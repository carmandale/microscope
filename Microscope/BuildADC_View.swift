//
//  ADC.swift
//  Microscope
//
//  Created by Dale Carman on 11/1/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ADC: View {
    @State private var showInfo = true
    
    var body: some View {
        RealityView { content, attachments in
            // Load and add the ADC scene
            if let scene = try? await Entity(named: "Scene", in: realityKitContentBundle) {
                content.add(scene)
            }
        } update: { content, attachments in
            // Update logic for 3D content if needed
        } attachments: {
            if showInfo {
                Attachment(id: "info") {
                    ADC_info_View()
                }
            }
        }
        .installGestures()
        
        // Optional toggle button for the info window
        VStack {
            Spacer()
            Button(action: { showInfo.toggle() }) {
                Label(showInfo ? "Hide Info" : "Show Info", 
                      systemImage: showInfo ? "info.circle.fill" : "info.circle")
            }
            .buttonStyle(.borderless)
            .padding()
        }
    }
}

#Preview {
    ADC()
}
