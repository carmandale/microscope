import SwiftUI
import RealityKitContent

/// Maintains app-wide state
@MainActor
@Observable
class AppModel {
    init() {
        RealityKitContent.GestureComponent.registerComponent()
        BreathComponent.registerComponent()
    }
    
    // Immersive space IDs
    let labSpaceID = "lab"
    let adcSpaceID = "adc"
    
    enum ImmersiveSpaceState {
        case closed
        case inTransition
        case open
    }
    
    var immersiveSpaceState = ImmersiveSpaceState.closed
    var currentSpaceID: String?  // Track which space is currently open
}
