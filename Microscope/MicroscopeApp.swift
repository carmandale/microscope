//
//  MicroscopeApp.swift
//  Microscope
//
//  Created by Dale Carman on 10/31/24.
//

import SwiftUI

@main
struct MicroscopeApp: App {
    @State private var appModel = AppModel()

    var body: some Scene {
        WindowGroup {
            GalleryView()
                .environment(appModel)
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
            ADC()
                .environment(appModel)
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
