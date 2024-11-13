import RealityKit
import RealityKitContent

/// The extension of the Entity class to create a component that loads a scene
/// and a function that implements a halo effect for multiple entities in the scene.
extension Entity {
    /// The name of the 3D scene resource file.
    static var fileName: String = "Blood"
    
    /// The scene property to hold the loaded scene.
    static var bloodScene: Entity?
    
    /// Loads the scene and assigns it to `bloodScene`.
    static func loadBloodScene() {
        do {
            let scene = try Entity.load(named: fileName, in: realityKitContentBundle)
            bloodScene = scene
            print("bloodScene loaded successfully")
        } catch {
            print("Failed to load bloodScene: \(error)")
        }
    }
    
    /// Retrieves the loaded `bloodScene`.
    static func getBloodScene() -> Entity? {
        return bloodScene
    }

    /// Assigns random transformations to the entities within the loaded scene.
    func addHalo(rotationSpeedMultiplier: Float = 1.0) {
        guard let bloodScene = Self.bloodScene else {
            print("Failed to add halo - bloodScene not loaded")
            return
        }
        
        let modelCount: Int = 10
        
        // Create multiple entities by cloning from the loaded scene and applying random transformations.
        for _ in 0..<modelCount {
            // Clone the loaded scene to create a new instance of the entity.
            let entity = bloodScene.clone(recursive: true)
            
            // Apply a random transformation and scale
            let rotate0 = Transform(rotation: simd_quatf(angle: .random(in: 0...(2 * .pi)), axis: [0, 1, 0])).matrix
            let translate = Transform(translation: [0, 0, 1]).matrix
            let rotate1 = Transform(rotation: simd_quatf(angle: .random(in: 0...(2 * .pi)), axis: [0, 1, 0])).matrix
            let rotate2 = Transform(rotation: simd_quatf(angle: .random(in: (-.pi / 9)...(.pi / 9)), axis: [1, 0, 0])).matrix
            entity.transform = Transform(matrix: rotate1 * rotate2 * translate * rotate0)
            
            entity.setScale(SIMD3(repeating: 0.1 * .random(in: 0.5...2)), relativeTo: entity)
            
            // Apply the rotation speed multiplier to the speed value.
            let baseSpeed: Float = .random(in: 0.001...0.1)
            let adjustedSpeed = baseSpeed * rotationSpeedMultiplier
            
            // Set the TurnTableComponent with the adjusted speed.
            entity.components.set(TurnTableComponent(
                rotationSpeed: adjustedSpeed,
                axisX: .random(in: -1...1),
                axisY: .random(in: -1...1),
                axisZ: .random(in: -1...1)
            ))
            
            // Add the entity as a child to the main entity.
            self.addChild(entity)
        }
    }
    
    func addBloodStream(width: Float, depth: Float, avgHeight: Float, flowSpeed: Float = 1.0) {
        let streamCount = 8  // Number of cells in the stream
        
        for _ in 0..<streamCount {
            // Clone this entity to create a new blood cell
            let bloodEntity = self.clone(recursive: true)
            
            // Position cells behind us (negative Z) initially
            let zPos = Float.random(in: -6...6)  // Start only behind us
            let xPos = Float.random(in: -3...3)  // 6 meters wide
            let yPos = Float.random(in: -3...3) - 1.0  // 6 meters high, shifted down 0.5m
            let position = SIMD3<Float>(xPos, yPos, zPos)
            bloodEntity.position = position
            
            // add rotation
            // Generate a random angle between 0 and 2π radians
            let angle = Float.random(in: 0...2) * .pi
            let axisX = Float.random(in: 0...2) * .pi
            let axisY = Float.random(in: 0...2) * .pi
            let axisZ = Float.random(in: 0...2) * .pi
            bloodEntity.setOrientation(simd_quatf(angle: angle, axis: SIMD3<Float>(axisX, axisY, axisZ)), relativeTo: bloodEntity)
            let axis = SIMD3<Float>(axisX, axisY, axisZ)
            bloodEntity.setOrientation(simd_quatf(angle: angle, axis: axis), relativeTo: bloodEntity)
            
            // Set constant scale for now
            let scale = Float.random(in: 0.6...1.0)
            bloodEntity.setScale(SIMD3(repeating: scale), relativeTo: nil)
            
            // Add BloodStreamComponent for forward motion
            bloodEntity.components.set(BloodStreamComponent(
                flowSpeed: (flowSpeed),
                initialPosition: position,
                streamWidth: 6.0,  // 6 meters wide
                streamDepth: 6.0   // 6 meters deep
            ))
            
            self.addChild(bloodEntity)
        }
    }
}
