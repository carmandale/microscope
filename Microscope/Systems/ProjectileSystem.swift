import RealityKit
import Foundation

class ProjectileSystem: RealityKit.System {
    // Query for entities with ADCComponent
    static let query = EntityQuery(where: .has(ADCComponent.self))
    
    private static let projectileSpeed: Float = 2.0     // Base speed
    private static let avoidanceDistance: Float = 0.5   // Distance to start avoiding
    private static let avoidanceForce: Float = 1.0      // Strength of avoidance
    private static let attachDistance: Float = 0.2      // Distance to attach to cancer cell
    
    required init(scene: RealityKit.Scene) {}
    
    func update(context: SceneUpdateContext) {
        let deltaTime = Float(context.deltaTime)
        
        context.scene.performQuery(Self.query).forEach { entity in
            guard var adc = entity.components[ADCComponent.self],
                  adc.isActive else { return }
            
            // Update lifetime
            adc.lifetime -= TimeInterval(deltaTime)
            if adc.lifetime <= 0 {
                entity.removeFromParent()
                return
            }
            
            // Update position based on velocity
            entity.position += adc.velocity * deltaTime
            
            // Check for collisions with cells
            checkCellInteractions(entity: entity, adc: &adc, scene: context.scene)
            
            // Update the component
            entity.components[ADCComponent.self] = adc
        }
    }
    
    private func checkCellInteractions(entity: Entity, adc: inout ADCComponent, scene: Scene) {
        // Find all entities with CellComponent
        scene.performQuery(EntityQuery(where: .has(CellComponent.self))).forEach { cellEntity in
            guard let cellComponent = cellEntity.components[CellComponent.self] else { return }
            
            let distance = simd_distance(entity.position, cellEntity.position)
            
            switch cellComponent.type {
            case .healthy:
                // Avoid healthy cells
                if distance < Self.avoidanceDistance {
                    let direction = normalize(entity.position - cellEntity.position)
                    adc.velocity += direction * Self.avoidanceForce
                    
                    // Maintain constant speed
                    adc.velocity = normalize(adc.velocity) * Self.projectileSpeed
                }
                
            case .cancer:
                // Attach to cancer cells
                if distance < Self.attachDistance {
                    adc.isActive = false
                    entity.setParent(cellEntity)
                    
                    // Update cancer cell state
                    var updatedCell = cellComponent
                    updatedCell.state = .targeted
                    cellEntity.components[CellComponent.self] = updatedCell
                }
            }
        }
    }
} 