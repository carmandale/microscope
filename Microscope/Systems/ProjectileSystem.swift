import RealityKit
import Foundation
import RealityKitContent

struct ProjectileSystem: System {
    static let query = EntityQuery(where: .has(ADCComponent.self))

    static let projectileSpeed: Float = 2.0
    private static let avoidanceDistance: Float = 0.5
    private static let avoidanceForce: Float = 1.0
    private static let attachDistance: Float = 0.2

    init(scene: Scene) { }

    func update(context: SceneUpdateContext) {
        // Use .rendering as the SystemUpdateCondition
        for entity in context.entities(matching: Self.query, updatingSystemWhen: .rendering) {
            guard var adc = entity.components[ADCComponent.self],
                  adc.isActive else { continue }
            
            // Update lifetime
            adc.lifetime -= TimeInterval(context.deltaTime)
            if adc.lifetime <= 0 {
                entity.removeFromParent()
                continue
            }

            // Update position based on velocity
            entity.position += adc.velocity * Float(context.deltaTime)
            
            // Check for collisions with cells
            checkCellInteractions(entity: entity, adc: &adc, scene: context.scene)
            
            // Update the component
            entity.components[ADCComponent.self] = adc
        }
    }

    private func checkCellInteractions(entity: Entity, adc: inout ADCComponent, scene: Scene) {
        // Find all entities with CellComponent
        let cellQuery = EntityQuery(where: .has(CellComponent.self))
        for cellEntity in scene.performQuery(cellQuery) {
            guard let cellComponent = cellEntity.components[CellComponent.self] else { continue }
            
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
