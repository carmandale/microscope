import RealityKit
import Foundation

public struct MovableEntityComponent: Component {
    public var lastPosition: SIMD3<Float>
    
    public init(position: SIMD3<Float>) {
        self.lastPosition = position
    }
} 
