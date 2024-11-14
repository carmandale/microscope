import RealityKit
import Foundation

public enum CellType: String, Sendable {
    case healthy
    case cancer
}

public struct CellComponent: Component, Sendable {
    public var type: CellType
    public var state: CellState = .normal

    public enum CellState: String, Sendable {
        case normal
        case targeted
        case destroyed
    }
    
    public init(type: CellType) {
        self.type = type
    }
}
