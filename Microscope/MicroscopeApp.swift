//
//  MicroscopeApp.swift
//  Microscope
//
//  Created by Dale Carman on 10/31/24.
//

import SwiftUI
import RealityKitContent

@main
struct MicroscopeApp: App {
    @State private var appModel = AppModel()
    @StateObject private var speedSettings = Settings()

    init() {
        RealityKitContent.GestureComponent.registerComponent()
        RealityKitContent.TurnTableComponent.registerComponent()
        RealityKitContent.BreathComponent.registerComponent()
        TurnTableSystem.registerSystem()
        BreathSystem.registerSystem()
        BloodStreamSystem.registerSystem()
    }

    var body: some Scene {
        WindowGroup {
            GalleryView()
                .environment(appModel)
                .environmentObject(speedSettings)
        }
        .windowStyle(.volumetric)

        // ImmersiveSpace for Lab
        ImmersiveSpace(id: appModel.labSpaceID) {
            ImmersiveView()
                .environment(appModel)
                .onAppear {
                    appModel.immersiveSpaceState = .open
                    appModel.currentSpaceID = appModel.labSpaceID
                }
                .onDisappear {
                    appModel.immersiveSpaceState = .closed
                    appModel.currentSpaceID = nil
                }
        }
        .immersionStyle(selection: .constant(.mixed), in: .mixed)

        // ImmersiveSpace for ADC
        ImmersiveSpace(id: appModel.adcSpaceID) {
            AttackCancerView()
                .environment(appModel)
                .environmentObject(speedSettings)
                .onAppear {
                    appModel.immersiveSpaceState = .open
                    appModel.currentSpaceID = appModel.adcSpaceID
                }
                .onDisappear {
                    appModel.immersiveSpaceState = .closed
                    appModel.currentSpaceID = nil
                }
        }
        .immersionStyle(selection: .constant(.mixed), in: .mixed)
    }
}
