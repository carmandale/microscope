import SwiftUI
import RealityKit
import RealityKitContent

class SceneStorage: ObservableObject {
    @Published var scene: Entity?
}

struct ADC: View {
    @EnvironmentObject var settings: Settings
    @State private var showInfo = true
    @StateObject private var sceneStorage = SceneStorage()
    
    let avgHeight: Float = 0.25

    var body: some View {
        RealityView { content in
            Entity.loadBloodScene()
            
            if let bloodEntity = Entity.getBloodScene() {
                var bloodTransform = bloodEntity.transform
                bloodTransform.translation.y += avgHeight
                bloodEntity.transform = bloodTransform
                
                // Call addBloodStream with parameters from settings
                bloodEntity.addBloodStream(
                    width: Float(settings.width),
                    depth: Float(settings.depth),
                    avgHeight: avgHeight,
                    flowSpeed: Float(settings.flowSpeed)
                )

                content.add(bloodEntity)
                
                if let loadedScene = try? await Entity(named: "Scene", in: realityKitContentBundle) {
                    content.add(loadedScene)
                    sceneStorage.scene = loadedScene
                } else {
                    print("Failed to load scene")
                }
            }
        } update: { content in
            // Update existing blood cells when settings change
            if let bloodEntity = Entity.getBloodScene() {
                for child in bloodEntity.children {
                    if let streamComp = child.components[BloodStreamComponent.self] {
                        // Update stream component with new settings
                        child.components.set(BloodStreamComponent(
                            flowSpeed: Float(settings.flowSpeed * settings.speedMultiplier),
                            initialPosition: child.position,
                            streamWidth: Float(settings.width),
                            streamDepth: Float(settings.depth)
                        ))
                    }
                }
            }
        }
    }
}
