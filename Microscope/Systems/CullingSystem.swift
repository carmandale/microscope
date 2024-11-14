import RealityKit
import Foundation
import RealityKitContent

class CullingSystem: System {
    static let query = EntityQuery(where: .has(CellComponent.self))
    
    // Spatial partitioning grid
    private var spatialGrid: [SIMD3<Int>: Set<Entity>] = [:]
    private let gridCellSize: Float = 2.0
    private let cullDistance: Float = 5.0
    
    // Required initializer for System protocol
    required init(scene: Scene) { }
    
    private func gridPosition(for worldPosition: SIMD3<Float>) -> SIMD3<Int> {
        SIMD3<Int>(
            Int(floor(worldPosition.x / gridCellSize)),
            Int(floor(worldPosition.y / gridCellSize)),
            Int(floor(worldPosition.z / gridCellSize))
        )
    }
    
    func update(context: SceneUpdateContext) {
        // Find camera entity
        guard let cameraEntity = context.scene.findEntity(named: "Camera") else { return }
        
        // Process entities matching our query
        for entity in context.entities(matching: Self.query, updatingSystemWhen: .rendering) {
            let distance = simd_distance(cameraEntity.position, entity.position)
            entity.isEnabled = distance <= cullDistance
            
            // Update spatial grid
            let gridPos = gridPosition(for: entity.position)
            spatialGrid[gridPos, default: []].insert(entity)
        }
    }
    
    // Helper method to update entity positions
    func updateEntityPosition(_ entity: Entity) {
        // Remove from old position
        for (gridPos, var entities) in spatialGrid {
            if entities.remove(entity) != nil {
                if entities.isEmpty {
                    spatialGrid.removeValue(forKey: gridPos)
                } else {
                    spatialGrid[gridPos] = entities
                }
                break
            }
        }
        
        // Add to new position
        let newGridPos = gridPosition(for: entity.position)
        spatialGrid[newGridPos, default: []].insert(entity)
    }
} 
