import Foundation
import RealityKit

public struct TurnTableComponent: Component, Codable {
    /// The rotation speed in radians per update.
    public var rotationSpeed: Float = 0.5
           
    /// Separate values for the axis that the object orbits around.
    public var axisX: Float = 0.0
    public var axisY: Float = 1.0
    public var axisZ: Float = 0.0
           
    /// Initialize the turntable component by setting the rotation speed and axis variables.
    public init(rotationSpeed: Float = Float.random(in: 0.1...1.0), axisX: Float = Float.random(in: 0.0...1.0), axisY: Float = Float.random(in: 0.0...1.0), axisZ: Float = Float.random(in: 0.0...1.0)) {
        self.rotationSpeed = rotationSpeed
        self.axisX = axisX
        self.axisY = axisY
        self.axisZ = axisZ
    }

    // Coding keys for encoding and decoding
    enum CodingKeys: String, CodingKey {
        case rotationSpeed, axisX, axisY, axisZ
    }
}
