To make this action plan more effective for a code-based Large Language Model (LLM), we need to provide **clear, actionable details** and **direct references** to specific code changes or enhancements. We'll also outline the **questions to ask** to clarify any ambiguities in the plan. Below is an updated version of the action plan tailored to guide a code LLM in refactoring and improving performance, followed by a list of key questions that should be addressed.

---

# Revised Microscope Cancer Attack System - Action Plan

## Project Context
- **Description**: A VisionOS application that visualizes cancer cell targeting using eye tracking to launch ADC projectiles at targeted cells.
- **Objective**: Refactor code to improve performance and implement proper eye tracking, drawing on patterns from the BOTanist reference code.

## Current State Overview
1. **Components in `RealityKitContent`**:
   - `CellComponent`
   - `ADCComponent`
   - `MovableEntityComponent`
2. **Systems**:
   - `CullingSystem`
   - `ProjectileSystem`
3. **Main Issues**:
   - Performance problems with entity updates.
   - Eye tracking is not properly implemented.
   - Lack of robust debugging tools.

## Reference Files from BOTanist
(These references provide architectural patterns and utility methods we aim to use or adapt.)
1. **Asset Management**:
   - `REFERENCE/RobotProvider.swift`
   - `REFERENCE/RobotProvider+Loading.swift`
   - `REFERENCE/AppState.swift`
2. **System Implementation**:
   - `REFERENCE/JointPinSystem.swift`
   - `REFERENCE/RobotCharacter.swift`
   - `REFERENCE/AnimationStateMachine.swift`
3. **Eye Tracking**:
   - `REFERENCE/ClubView.swift`
   - `REFERENCE/AppState+Exploration.swift`
4. **Debug Tools**:
   - `REFERENCE/EntityExtensions.swift`
   - `REFERENCE/Entity+Debug.swift`

## Implementation Phases

### Phase 1: Performance Optimization
**Goal**: Improve entity management and update performance.

1. **Asset Loading**:
   - [ ] **Create `MicroscopeProvider`** similar to `RobotProvider` to handle loading of assets.
     - Implementation details:
       - Follow the pattern in `RobotProvider.swift` and `RobotProvider+Loading.swift`.
       - Use parallel asset loading techniques to reduce load times.
       - Implement asset caching for reusable assets.
     - **Files to Create/Update**:
       - `MicroscopeProvider.swift`
       - `MicroscopeProvider+Loading.swift`
   - [ ] **Refactor asset loading logic** in `AttackCancerView` to use `MicroscopeProvider`.

2. **Entity Management**:
   - [ ] **Optimize ADC projectile pooling**:
     - Create a pooling mechanism for `ADCComponent` entities to reuse them instead of creating new ones each time, following patterns in `BOTanist` (e.g., how `RobotCharacter` handles reusable components).
     - Ensure that inactive ADC entities are recycled properly.
     - **Files to Update**:
       - `AttackCancerView.swift`
       - `ProjectileSystem.swift`
   - [ ] **Implement proper entity lifecycle management**:
     - Introduce standardized methods for entity creation, activation, deactivation, and destruction, referencing patterns from `AnimationStateMachine` and `AppState`.
     - **Files to Update**:
       - `CullingSystem.swift` (adjusting how entities are removed or hidden)
       - Possibly `MovableEntityComponent` to handle lifecycle states

3. **System Updates**:
   - [ ] **Update `CullingSystem` for efficient queries**:
     - Enhance the system to cull entities not in view or not needed to be updated, reducing performance overhead.
     - Use batch processing of entities where possible.
   - [ ] **Add frame rate control**:
     - Implement logic to throttle updates to certain systems based on performance metrics, referencing patterns from `JointPinSystem`.
     - **Files to Update**:
       - `CullingSystem.swift`
       - `ProjectileSystem.swift`
       - Possibly create or update a system to track performance metrics and decide update frequency

### Phase 2: Eye Tracking
**Goal**: Implement a proper targeting system using the user's gaze data.

1. **Components**:
   - [ ] **Create `TargetableComponent`**:
     - This component will store data related to targeting, such as whether an entity can be targeted by eye tracking.
     - Integrate with `CellComponent` and `ADCComponent` as needed.
     - **Files to Create**:
       - `TargetableComponent.swift` in `RealityKitContent`

2. **Systems**:
   - [ ] **Create `TargetingSystem`**:
     - This system will handle logic for determining which entity is being targeted by the user's gaze.
     - Adapt logic from `ClubView.swift` and `AppState+Exploration.swift` in BOTanist to accurately map eye gaze to target entities.
     - Implement visual feedback, such as highlighting or reticle placement on targeted cells.
     - **Files to Create**:
       - `TargetingSystem.swift`
     - **Files to Update**:
       - Possibly `AttackCancerView.swift` to integrate system logic
       - Possibly `ProjectileSystem` to handle when a projectile is launched at the target

### Phase 3: Debug Tools
**Goal**: Implement robust debugging support and performance visualization.

1. **Debug Components**:
   - [ ] **Add visualization components**:
     - Implement debug overlays or entity outlines to show targeting and culling in action.
     - Adapt patterns from `EntityExtensions.swift` and `Entity+Debug.swift` for debug visualization.
     - **Files to Create/Update**:
       - `DebugComponents.swift` in `RealityKitContent`
       - Extend `Entity+Debug.swift` to visualize performance metrics
   - [ ] **Implement performance metrics tracking**:
     - Create or update components/systems to measure FPS and entity update counts.
     - Provide a debug interface (console output or overlay) to display these metrics in real-time.
     - **Files to Update**:
       - `AppState.swift` (possibly to store and manage performance data)
       - `AttackCancerView.swift` or a new debug view for performance metrics

## Verification Steps
Each phase must be verified by:
1. **Building and running** the application.
2. **Testing specific functionality**:
   - **Phase 1**:
     - Verify performance metrics to ensure improved entity management.
     - Test with 100+ entities to ensure smooth performance.
   - **Phase 2**:
     - Validate that eye tracking correctly targets cells.
     - Measure latency to ensure responsive targeting (< 100ms).
   - **Phase 3**:
     - Check debug visualization tools for clarity and accuracy.
     - Ensure performance metrics are displayed and updated in real-time.

## Success Criteria
- [ ] Application runs smoothly with 100+ entities.
- [ ] Eye tracking targeting is responsive and accurate.
- [ ] Clear debug visualization and performance metrics.
- [ ] Efficient entity and asset management following best practices.

---

## Questions to Clarify
To refine this plan further, we need additional information and confirmation on several points. Here are some questions that would help clarify requirements and guide the refactoring process:

1. **Asset and Entity Lifecycle**:
   - Are there specific asset management patterns or caching mechanisms that should be followed beyond the BOTanist references?
   - How exactly are the current entities (cells, projectiles) created and destroyed, and what improvements are expected?

2. **Eye Tracking Implementation**:
   - How is the eye tracking data currently integrated into the application, and what are the specific shortcomings of this integration?
   - What level of accuracy and latency is acceptable for targeting, and how can we measure and ensure it?

3. **Performance Targets**:
   - What performance issues are being observed currently (e.g., frame drops, lag, slow entity updates)?
   - Are there any specific memory usage constraints or CPU/GPU load constraints we aim to meet?

4. **Debug Tools**:
   - What kind of debug information is most critical to display (entity states, performance metrics, system updates)?
   - Should debug tools be integrated as an overlay in the application or as console output?

5. **Integration and Dependencies**:
   - Are there any constraints regarding how BOTanist code is integrated? (e.g., licensing, code style, or structural constraints)
   - Do we have access to all BOTanist reference code and is it compatible with the current project codebase?

6. **Testing and Verification**:
   - How will we measure and validate performance improvements quantitatively?
   - Is there a suite of tests (unit tests, UI tests) that should be updated or created to verify these changes?

### Example Clarifications for Code LLM Guidance
- Confirm directory structure and naming conventions for new files (e.g., `MicroscopeProvider+Loading.swift`).
- Confirm whether the code LLM should create stubs for testing or if testing is handled separately.
- Clarify if the code LLM can introduce new dependencies (like performance profiling libraries) or must stick to existing frameworks.

---

