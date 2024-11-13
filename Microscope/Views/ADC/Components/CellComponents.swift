import RealityKit
import Foundation

enum CellType {
    case healthy
    case cancer
}

struct CellComponent: Component {
    let type: CellType
    var state: CellState = .normal
    
    enum CellState {
        case normal
        case targeted
        case destroyed
    }
}

struct ADCComponent: Component {
    var velocity: SIMD3<Float>
    var isActive: Bool = true
    var lifetime: TimeInterval = 30.0  // Maximum lifetime in seconds
} 