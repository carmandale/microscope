import RealityKit
import Foundation

public struct ADCComponent: Component {
    public var velocity: SIMD3<Float>
    public var isActive: Bool
    public var lifetime: TimeInterval
    
    public init(velocity: SIMD3<Float> = .zero, isActive: Bool = true, lifetime: TimeInterval = 5.0) {
        self.velocity = velocity
        self.isActive = isActive
        self.lifetime = lifetime
    }
}
