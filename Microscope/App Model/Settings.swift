import SwiftUI
import Combine

class Settings: ObservableObject {
    @Published var speedMultiplier: Double = 1 // Rotation speed of halo
    @Published var width: Double = 3.0     // Width of the blood cell stream
    @Published var depth: Double = 6.0     // Depth of the blood cell stream
    @Published var flowSpeed: Double = 1.0  // Flow speed of blood cells
}
