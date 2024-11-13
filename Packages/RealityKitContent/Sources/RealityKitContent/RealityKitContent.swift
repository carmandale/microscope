import RealityKit
import Foundation

/// Bundle for the RealityKitContent project
public let realityKitContentBundle = Bundle.module

/// Register custom components and systems
public func registerComponents() {
    // Existing components
    GestureComponent.registerComponent()
    BreathComponent.registerComponent()
    
    // New components
    TurnTableComponent.registerComponent()
    BloodStreamComponent.registerComponent()
}

public func registerSystems() {
    // Systems are registered when the scene subscribes to them
}
