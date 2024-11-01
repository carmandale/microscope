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
    var body: some View {
        RealityView { content in
            if let scene = try? await Entity(named: "Scene", in: realityKitContentBundle) {
                content.add(scene)
            }
        }
        .installGestures()
    }
}

#Preview {
    ADC()
}
