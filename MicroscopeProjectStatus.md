# Microscope Project Status and Plan

## Current State
- Basic functionality working but with performance issues
- Components moved to RealityKitContent package
- Systems registered in MicroscopeApp.swift
- Current implementation has performance issues with updates and entity management

## Key Learnings from BOTanist
1. Component Structure:
   - Components are simple data structures
   - Located in RealityKitContent package
   - Public, Codable, and often Sendable
   - Clear initialization patterns
   - Only store data, no logic
   - Components registered in App initialization

2. System Patterns:
   - Clear query definitions using EntityQuery
   - Efficient update cycles using SceneUpdateContext
   - Systems focus on single responsibility
   - Proper component updates with state management
   - Systems registered in App initialization

3. Performance Patterns:
   - Batch processing for entity creation
   - Entity pooling for frequently created/destroyed entities
   - Efficient updates using proper System patterns
   - Debug visualization for performance monitoring
   - Spatial partitioning for large entity sets

## Current Implementation

### Components
1. CellComponent (RealityKitContent):
   - Stores cell type (healthy/cancer)
   - Tracks cell state
   - Properly structured but needs Codable

2. ADCComponent (RealityKitContent):
   - Stores velocity and active state
   - Manages lifetime
   - Needs proper Codable implementation

3. MovableEntityComponent (RealityKitContent):
   - Tracks position
   - Needs proper Codable implementation
   - Currently duplicated in project

### Systems
1. CullingSystem:
   - Basic distance-based culling
   - Needs optimization
   - Should follow BOTanist patterns

2. ProjectileSystem:
   - Handles ADC movement
   - Needs optimization
   - Should follow BOTanist patterns

### Main View (AttackCancerView)
- Handles entity creation and management
- Currently doing too much work directly
- Should delegate more to Systems
- Needs proper eye tracking implementation

## Performance Issues
1. Entity Updates:
   - Too frequent updates
   - Inefficient batch processing
   - Need proper System update cycles

2. Entity Management:
   - ADC pooling needs optimization
   - Cell creation could be more efficient
   - Need proper spatial partitioning

3. Targeting and Interaction:
   - Eye tracking not properly implemented
   - Need efficient targeting system
   - Should follow HappyBeam patterns

## Performance Optimization Insights

### 1. MainActor Usage
- Current Issue: Too many MainActor.run calls in processBatch
- Solution: Batch entity additions
- Reference: BOTanist/Systems/DanceMotivationSystem.swift for batch processing

### 2. Entity Pooling
- Current Issue: Inefficient ADC pooling
- Solution: Optimize pool initialization and management
- Reference: SwiftSplash/TrackPieces/Components/ConnectableStateComponent.swift

### 3. Entity Lookups
- Current Issue: Frequent camera entity lookups
- Solution: Cache static entities
- Reference: BOTanist/Views/ClubView.swift for entity caching

### 4. Transform Calculations
- Current Issue: Repeated transform calculations
- Solution: Batch and cache transforms
- Reference: BOTanist/Systems/JointPinSystem.swift for transform handling

## Next Steps

### Immediate Tasks
1. Fix Component Structure:
   - Ensure all components are in RealityKitContent
   - Add proper Codable conformance
   - Remove duplicate MovableEntityComponent

2. Implement Proper Systems:
   - Create ADCSystem following BOTanist patterns
   - Optimize CullingSystem
   - Add debug visualization

3. Optimize Entity Management:
   - Implement proper entity pooling
   - Add spatial partitioning
   - Optimize batch processing

### Future Improvements
1. Eye Tracking:
   - Study HappyBeam implementation
   - Add proper targeting feedback
   - Implement efficient targeting system

2. Debug Tools:
   - Add performance visualization
   - Implement debug controls
   - Add system state monitoring

3. Visual Effects:
   - Add proper targeting highlights
   - Implement cell destruction effects
   - Add particle systems

## Reference Examples
1. BOTanist:
   - RevolvingSystem for efficient updates
   - Debug visualization patterns
   - Component structure

2. HappyBeam:
   - Targeting system
   - Eye tracking implementation
   - Visual feedback

3. SwiftSplash:
   - Entity pooling
   - System organization
   - Component registration

## Questions to Address
1. How to implement efficient eye tracking?
2. Best way to handle entity pooling?
3. How to optimize batch processing?
4. Proper debug visualization implementation?
5. Best practices for system updates?

## Files to Focus On
1. AttackCancerView.swift
2. Components in RealityKitContent
3. System implementations
4. MicroscopeApp.swift for registration

## Notes
- Need to maintain clear separation of concerns
- Follow Apple's patterns where possible
- Focus on performance optimization
- Consider debug tools from start
- Keep system implementations simple and focused

## Reference Files Needed from BOTanist
1. Component Examples:
   - BOTanist/Components/JointPinComponent.swift - Shows proper component structure
   - BOTanist/Components/PlantComponent.swift - Another example of component design
   - BOTanist/Components/RevolvingComponent.swift - Simple state component

2. System Examples:
   - BOTanist/Systems/JointPinSystem.swift - Shows proper system structure
   - BOTanist/Systems/RevolvingSystem.swift - Simple update system
   - BOTanist/Systems/DanceMotivationSystem.swift - Complex system with debug

3. Debug Examples:
   - BOTanist/Systems/DanceMotivationSystem.swift - Shows debug visualization
   - BOTanist/Extensions/Entity+Debug.swift - Debug helper methods

## BOTanist Implementation Patterns to Follow

### 1. Component Pattern
From BOTanist's RevolvingComponent:
```swift
public struct RevolvingComponent: Component {
    var speed: Float
    var angle: Float
    var axis: SIMD3<Float>
    var relativeTo: Entity?
    
    public init(speed: Float = 0.05, initialAngle: Float = 0, axis: SIMD3<Float> = [0, 1, 0], relativeTo: Entity? = nil) {
        self.speed = speed
        self.angle = initialAngle
        self.axis = axis
        self.relativeTo = relativeTo
    }
}
```

Key patterns:
- Simple data structure
- Clear initialization
- Default values in init
- Only stores state, no logic
- Public interface
- References to other entities through optional Entity

### 2. System Pattern
From BOTanist's RevolvingSystem:
```swift
@MainActor
class RevolvingSystem: System {
    private static let query = EntityQuery(where: .has(RevolvingComponent.self))
    
    required init(scene: RealityKit.Scene) {}
    
    func update(context: SceneUpdateContext) {
        for entity in context.entities(matching: Self.query, updatingSystemWhen: .rendering) {
            if var revolvingComponent = entity.components[RevolvingComponent.self] {
                let relativeTo = revolvingComponent.relativeTo
                
                revolvingComponent.angle += .pi * Float(context.deltaTime) * revolvingComponent.speed
                entity.setOrientation(.init(angle: revolvingComponent.angle, axis: revolvingComponent.axis), 
                                   relativeTo: relativeTo)
                
                entity.components[RevolvingComponent.self] = revolvingComponent
            }
        }
    }
}
```

Key patterns:
- @MainActor annotation
- Static query definition
- Required init(scene:)
- Updates components through entity.components
- Uses updatingSystemWhen for performance
- Clear single responsibility

### 3. Debug Pattern
From BOTanist's DanceSystemDebugComponent:
```swift
struct DanceSystemDebugComponent: Component {
    var states: UIImage? = nil
    var vacant: Int = 0
    var attracting: Int = 0
    var motivating: Int = 0
}

#if DEBUG
extension Entity {
    func addDebugMarker(radius: Float, color: UIColor) {
        let marker = ModelEntity(...)
        addChild(marker)
    }
}
#endif
```

Key patterns:
- Debug components separate from main components
- Visual debug helpers in extensions
- Metrics tracking in debug components
- #if DEBUG conditional compilation

### 4. Entity Management Pattern
From BOTanist's DanceMotivationSystem:
```swift
@MainActor
class DanceMotivationSystem: System {
    private static let query = EntityQuery(where: .has(AutomatonControl.self))
    
    func update(context: SceneUpdateContext) {
        // Batch process entities
        var entitiesToUpdate: [Entity] = []
        
        for entity in context.entities(matching: Self.query, updatingSystemWhen: .rendering) {
            // Collect entities that need updates
            if needsUpdate(entity) {
                entitiesToUpdate.append(entity)
            }
        }
        
        // Perform updates in batch
        for entity in entitiesToUpdate {
            updateEntity(entity)
        }
    }
}
```

Key patterns:
- Batch processing of entities
- Collect then update pattern
- Efficient query usage
- Clear update criteria

## BOTanist Patterns for Attraction and Targeting

### 1. Attraction System Pattern
From BOTanist's DanceMotivationSystem:
```swift
struct AttractorComponent: Component {
    enum State {
        case vacant
        case attracting
        case motivating
    }
    
    private(set) var state: State = .vacant
    var target: Entity?
    var walkSpeed: Float = 0.1
    var interval: TimeInterval = 5
    var countdown: TimeInterval = 5
    var club: Entity?
    
    var isVacant: Bool {
        if case .vacant = state { return true }
        return false
    }
    
    mutating func setTarget(_ target: Entity) {
        self.target = target
        self.state = .attracting
    }
}

@MainActor
class DanceMotivationSystem: System {
    private static let attractorQuery = EntityQuery(where: .has(AttractorComponent.self))
    private static let targetQuery = EntityQuery(where: .has(Newcomer.self))
    
    func update(context: SceneUpdateContext) {
        // Find available targets
        for visitor in context.entities(matching: Self.targetQuery, updatingSystemWhen: .rendering) {
            // Find available attractor
            guard let attractor = context.entities(matching: Self.attractorQuery)
                .filter({ $0.components[AttractorComponent.self]?.isVacant ?? false })
                .randomElement() else { return }
            
            // Start attraction
            var attractorComponent = attractor.components[AttractorComponent.self]!
            attractorComponent.setTarget(visitor)
            attractor.components[AttractorComponent.self] = attractorComponent
        }
        
        // Update attractions
        for attractor in context.entities(matching: Self.attractorQuery) {
            guard var attractorComponent = attractor.components[AttractorComponent.self] else { continue }
            
            switch attractorComponent.state {
            case .attracting:
                updateAttraction(attractor: attractor, component: &attractorComponent)
            case .motivating:
                updateMotivation(attractor: attractor, component: &attractorComponent)
            default:
                break
            }
            
            attractor.components[AttractorComponent.self] = attractorComponent
        }
    }
    
    private func updateAttraction(attractor: Entity, component: inout AttractorComponent) {
        guard let target = component.target else { return }
        
        // Calculate movement
        let targetPosition = target.position
        let attractorPosition = attractor.position
        let direction = normalize(attractorPosition - targetPosition)
        let speed = component.walkSpeed
        
        // Move target towards attractor
        target.position += direction * speed
        
        // Check if reached
        if distance(targetPosition, attractorPosition) < 0.01 {
            component.state = .motivating
        }
    }
}
```

Key patterns:
- Clear state management in component
- Separate queries for attractors and targets
- Efficient movement calculations
- State-based behavior updates

### 2. Eye Tracking Pattern
From BOTanist's targeting system:
```swift
struct TargetableComponent: Component {
    var isTargeted: Bool = false
    var lastTargetTime: TimeInterval = 0
    var targetDuration: TimeInterval = 0.5
}

@MainActor
class TargetingSystem: System {
    static let query = EntityQuery(where: .has(TargetableComponent.self))
    
    func update(context: SceneUpdateContext) {
        let currentTime = CACurrentMediaTime()
        
        for entity in context.entities(matching: Self.query, updatingSystemWhen: .rendering) {
            guard var targetable = entity.components[TargetableComponent.self] else { continue }
            
            if targetable.isTargeted {
                let timeTargeted = currentTime - targetable.lastTargetTime
                if timeTargeted >= targetable.targetDuration {
                    // Target acquired
                    handleTargetAcquired(entity)
                }
            }
            
            entity.components[TargetableComponent.self] = targetable
        }
    }
}

// In View:
RealityView { content in
    // ... setup
}
.targetedLookOptions(.enabled)
.lookAtTarget { target, _ in
    if let entity = target.entity,
       var targetable = entity.components[TargetableComponent.self] {
        targetable.isTargeted = true
        targetable.lastTargetTime = CACurrentMediaTime()
        entity.components[TargetableComponent.self] = targetable
        
        // Add visual feedback
        addTargetingFeedback(to: entity)
    }
}
```

Key patterns:
- Separate targeting component
- Time-based targeting validation
- Clear visual feedback
- System handles target acquisition

### Application to Our Project
1. ADC Targeting System:
```swift
public struct ADCTargetComponent: Component, Codable {
    public var isTargeted: Bool = false
    public var targetingProgress: Float = 0
    public var target: Entity?
    
    public init() {}
}

@MainActor
class ADCTargetingSystem: System {
    static let query = EntityQuery(where: .has(CellComponent.self))
    
    func update(context: SceneUpdateContext) {
        // Update targeting progress
        // Handle target acquisition
        // Manage visual feedback
    }
}
```

2. ADC Attraction System:
```swift
public struct ADCAttractionComponent: Component, Codable {
    public enum State {
        case seeking
        case pursuing
        case attacking
    }
    
    public var state: State = .seeking
    public var target: Entity?
    public var speed: Float = 1.0
    
    public init() {}
}
```

## Component Updates Needed
1. CellComponent:
   - Add Codable conformance
   - Add proper debug support
   - Consider adding position tracking

2. ADCComponent:
   - Add Codable conformance
   - Add Sendable conformance
   - Add proper initialization patterns
   - Consider adding state management

3. MovableEntityComponent:
   - Add Codable conformance
   - Add Sendable conformance
   - Consider merging with other movement components
   - Add proper state tracking

## System Updates Needed
1. Create new systems following BOTanist patterns:
   - ADCSystem for projectile management
   - TargetingSystem for eye tracking
   - CellSystem for cell management

2. Update existing systems:
   - CullingSystem needs proper query and update cycle
   - ProjectileSystem needs optimization
   - Add debug visualization to all systems

## Additional Files Needed

### From BOTanist:
1. Performance Examples:
   - BOTanist/Systems/DanceMotivationSystem.swift - Shows batch processing
   - BOTanist/Views/ClubView.swift - Shows entity caching
   - BOTanist/Systems/RevolvingSystem.swift - Shows efficient updates

2. Debug Examples:
   - BOTanist/Extensions/Entity+Debug.swift - Debug visualization
   - BOTanist/Components/DanceSystemDebugComponent.swift - Debug state

### From SwiftSplash:
1. Entity Management:
   - SwiftSplash/TrackPieces/Components/ConnectableStateComponent.swift
   - SwiftSplash/Systems/TrackSystem.swift

### From HappyBeam:
1. Targeting System:
   - HappyBeam/Gameplay/BeamCollisions.swift
   - HappyBeam/Views/HappyBeam.swift

## Implementation Plan

### Phase 1: Component Optimization
1. Update Components:
   ```swift
   // Example from BOTanist
   public struct CellComponent: Component, Codable, Sendable {
       public var type: CellType
       public var state: CellState
       // Add debug support
   }
   ```

### Phase 2: System Optimization
1. Create ADCSystem:
   ```swift
   // Example pattern from BOTanist
   @MainActor
   class ADCSystem: System {
       private static let query = EntityQuery(where: .has(ADCComponent.self))
       // Add efficient update cycle
   }
   ```

### Phase 3: Debug Implementation
1. Add Debug Components:
   ```swift
   // Example from BOTanist
   struct DebugComponent: Component {
       var states: UIImage?
       var metrics: [String: Any]
   }
   ```

## BOTanist Asset Loading and System Update Patterns

### 1. Asset Loading Pattern
From BOTanist's ClubView:
```swift
@Observable
@MainActor
final class ClubViewState: Sendable {
    let rootEntity = Entity()
    private var loadedEnvironmentRoot: Entity?
    
    // Cache loaded assets
    private var cachedModels: [String: Entity] = [:]
    
    func loadEnvironment() async {
        guard loadedEnvironmentRoot == nil else { return }
        
        // Load all required models in parallel
        async let environmentTask = Entity.load(named: "scenes/volume", in: BOTanistAssetsBundle)
        async let model1Task = Entity.load(named: "model1", in: BOTanistAssetsBundle)
        async let model2Task = Entity.load(named: "model2", in: BOTanistAssetsBundle)
        
        do {
            let (environment, model1, model2) = try await (
                environmentTask,
                model1Task,
                model2Task
            )
            
            // Cache loaded models
            cachedModels["environment"] = environment
            cachedModels["model1"] = model1
            cachedModels["model2"] = model2
            
            // Setup scene hierarchy
            await MainActor.run {
                self.setupSceneHierarchy(environment, model1, model2)
            }
        } catch {
            logger.error("Failed to load models: \(error.localizedDescription)")
        }
    }
    
    private func setupSceneHierarchy(_ environment: Entity, _ model1: Entity, _ model2: Entity) {
        // Add in specific order
        rootEntity.addChild(environment)
        
        // Configure initial transforms
        environment.position = .zero
        
        // Add components after hierarchy setup
        environment.components[SomeComponent.self] = SomeComponent()
    }
}
```

Key patterns:
- Parallel asset loading
- Asset caching
- Clear error handling
- MainActor for scene setup
- Hierarchy setup after loading

### 2. System Update Pattern
From BOTanist's DanceMotivationSystem:
```swift
@MainActor
class DanceMotivationSystem: System {
    // Queries
    private static let primaryQuery = EntityQuery(where: .has(DanceComponent.self))
    private static let targetQuery = EntityQuery(where: .has(TargetComponent.self))
    
    // Cached state
    private var lastUpdateTime: TimeInterval = 0
    private var updateInterval: TimeInterval = 1.0/60.0  // 60fps
    private var entitiesToUpdate: [Entity] = []
    
    required init(scene: Scene) {
        // System initialization
    }
    
    func update(context: SceneUpdateContext) {
        let currentTime = CACurrentMediaTime()
        guard (currentTime - lastUpdateTime) >= updateInterval else { return }
        
        // Clear previous update batch
        entitiesToUpdate.removeAll(keepingCapacity: true)
        
        // Collect entities that need updates
        for entity in context.entities(matching: Self.primaryQuery, 
                                     updatingSystemWhen: .rendering) {
            if needsUpdate(entity, context: context) {
                entitiesToUpdate.append(entity)
            }
        }
        
        // Batch process updates
        processUpdateBatch(context)
        
        lastUpdateTime = currentTime
    }
    
    private func needsUpdate(_ entity: Entity, context: SceneUpdateContext) -> Bool {
        // Efficient update check
        guard let component = entity.components[DanceComponent.self] else { return false }
        
        // Check if update needed based on state
        return component.needsUpdate
    }
    
    private func processUpdateBatch(_ context: SceneUpdateContext) {
        // Group similar operations
        var transformUpdates: [(Entity, Transform)] = []
        var componentUpdates: [(Entity, Component)] = []
        
        // Collect all updates
        for entity in entitiesToUpdate {
            if let update = calculateUpdate(for: entity) {
                transformUpdates.append(update.transform)
                componentUpdates.append(update.component)
            }
        }
        
        // Apply updates in batches
        for (entity, transform) in transformUpdates {
            entity.transform = transform
        }
        
        for (entity, component) in componentUpdates {
            entity.components[type(of: component)] = component
        }
    }
}
```

Key patterns:
- Frame rate control
- Batch processing
- State caching
- Efficient queries
- Grouped operations

### 3. Performance Optimization Patterns
```swift
// 1. Entity Pooling
class EntityPool {
    private var available: [Entity] = []
    private var active: Set<Entity> = []
    private let capacity: Int
    
    init(capacity: Int, template: Entity) {
        self.capacity = capacity
        // Preallocate pool
        available = (0..<capacity).map { _ in
            let entity = template.clone(recursive: true)
            entity.isEnabled = false
            return entity
        }
    }
    
    func obtain() -> Entity? {
        guard let entity = available.popLast() else { return nil }
        entity.isEnabled = true
        active.insert(entity)
        return entity
    }
    
    func recycle(_ entity: Entity) {
        guard active.contains(entity) else { return }
        entity.isEnabled = false
        active.remove(entity)
        available.append(entity)
    }
}

// 2. Spatial Partitioning
struct SpatialGrid {
    private var cells: [SIMD3<Int>: Set<Entity>] = [:]
    private let cellSize: Float
    
    func nearbyEntities(to position: SIMD3<Float>, radius: Float) -> [Entity] {
        // Efficient spatial lookup
    }
    
    mutating func update(_ entity: Entity) {
        // Efficient position update
    }
}

// 3. Component Updates
extension Entity {
    func updateComponent<T: Component>(_ update: (inout T) -> Void) {
        guard var component = components[T.self] else { return }
        update(&component)
        components[T.self] = component
    }
}
```

### 4. Debug Visualization Pattern
```swift
#if DEBUG
struct DebugVisualization {
    static func addMarker(to entity: Entity, color: UIColor) {
        let marker = ModelEntity(...)
        marker.name = "[Debug] \(entity.name)"
        entity.addChild(marker)
    }
    
    static func updateVisualization(_ entity: Entity, metrics: DebugMetrics) {
        guard let debugComponent = entity.components[DebugComponent.self] else { return }
        // Update visualization
    }
}
#endif
```