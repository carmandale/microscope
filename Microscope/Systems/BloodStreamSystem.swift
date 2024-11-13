import RealityKit
import RealityKitContent
import Foundation

struct BloodStreamSystem: System {
    static let query = EntityQuery(where: .has(BloodStreamComponent.self))
    
    init(scene: Scene) { }
    
    func update(context: SceneUpdateContext) {
        for entity in context.entities(matching: Self.query, updatingSystemWhen: .rendering) {
            guard let stream = entity.components[BloodStreamComponent.self] else { continue }
            
            // set a random rotation
            // Apply rotation directly based on `rotationSpeed`
//            let angle = 1.1 * Float(context.deltaTime)
//            let axisX = Float(.random(in: -0.1...0.1))
//            let axisY = Float(.random(in: -0.1...0.1))
//            let axisZ = Float(.random(in: -0.1...0.1))
//            entity.setOrientation(simd_quatf(angle: angle, axis: SIMD3<Float>(axisX, axisY, axisZ)), relativeTo: entity)
//            let axis = SIMD3<Float>(axisX, axisY, axisZ)
//            entity.setOrientation(simd_quatf(angle: angle, axis: axis), relativeTo: entity)
            
            // Move forward (negative Z direction)
            entity.position.z -= stream.flowSpeed * Float(context.deltaTime)
            
            // Reset position when cell moves too far forward
            if entity.position.z < -6 {  // When it's too far in front
                entity.position.z = 3   // Reset to behind us
                entity.position.x = .random(in: -3...3)
                entity.position.y = .random(in: -3...3) - 1
            }
        }
    }
} 
