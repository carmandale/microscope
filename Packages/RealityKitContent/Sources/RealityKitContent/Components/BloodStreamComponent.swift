import RealityKit
import Foundation

public struct BloodStreamComponent: Component, Codable {
    /// Flow speed in meters per second
    public var flowSpeed: Float = 0.5
    /// Initial position in the stream
    public var initialPosition: SIMD3<Float> = .zero
    /// Stream width and depth bounds
    public var streamWidth: Float = 6.0
    public var streamDepth: Float = 6.0
    
    public init(flowSpeed: Float = Float.random(in: 0.1...1.0), 
                initialPosition: SIMD3<Float>,
                streamWidth: Float,
                streamDepth: Float) {
        self.flowSpeed = flowSpeed
        self.initialPosition = initialPosition
        self.streamWidth = streamWidth
        self.streamDepth = streamDepth
    }
} 
