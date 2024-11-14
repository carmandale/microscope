# Microscope Cancer Attack System - Action Plan

## Project Context
- VisionOS app for visualizing cancer cell targeting
- Uses eye tracking for targeting cancer cells
- Launches ADC projectiles at targeted cells
- Currently has performance issues with entity management

## Current State
1. Components (in RealityKitContent):
   - CellComponent
   - ADCComponent
   - MovableEntityComponent

2. Systems:
   - CullingSystem
   - ProjectileSystem

3. Main Issues:
   - Performance problems with entity updates
   - Need proper eye tracking implementation
   - Need better debug tools

## Reference Files from BOTanist
1. Asset Management:
   - BOTanist/Robot/RobotProvider.swift
   - BOTanist/Robot/RobotProvider+Loading.swift
   - BOTanist/AppState.swift

2. System Implementation:
   - BOTanist/Systems/JointPinSystem.swift
   - BOTanist/Robot/RobotCharacter.swift
   - BOTanist/Robot/AnimationStateMachine.swift

3. Eye Tracking:
   - BOTanist/Views/ClubView.swift
   - BOTanist/AppState+Exploration.swift

4. Debug Tools:
   - BOTanist/Extensions/EntityExtensions.swift
   - BOTanist/Extensions/Entity+Debug.swift

## Implementation Phases

### Phase 1: Performance Optimization
Goal: Improve entity management and update performance

1. Asset Loading:
   - [ ] Create MicroscopeProvider following RobotProvider pattern
   - [ ] Implement parallel asset loading
   - [ ] Add asset caching
   Files to Create:
   - MicroscopeProvider.swift
   - MicroscopeProvider+Loading.swift

2. Entity Management:
   - [ ] Optimize ADC pooling using BOTanist patterns
   - [ ] Implement proper entity lifecycle
   Files to Update:
   - AttackCancerView.swift
   - ProjectileSystem.swift

3. System Updates:
   - [ ] Update CullingSystem with efficient queries
   - [ ] Add frame rate control
   - [ ] Implement batch processing
   Files to Update:
   - CullingSystem.swift

### Phase 2: Eye Tracking
Goal: Implement proper targeting system

1. Components:
   - [ ] Create TargetableComponent
   - [ ] Add targeting state management
   Files to Create:
   - TargetableComponent.swift in RealityKitContent

2. Systems:
   - [ ] Create TargetingSystem
   - [ ] Add visual feedback
   Files to Create:
   - TargetingSystem.swift

### Phase 3: Debug Tools
Goal: Add proper debugging support

1. Debug Components:
   - [ ] Add visualization components
   - [ ] Add performance metrics
   Files to Create:
   - DebugComponents.swift in RealityKitContent
   - Entity+Debug.swift

## Verification Steps
Each phase must be verified by:
1. Building and running
2. Testing specific functionality:
   - Phase 1: Performance metrics
   - Phase 2: Targeting accuracy
   - Phase 3: Debug visualization

## Success Criteria
- [ ] Smooth performance with 100+ entities
- [ ] Responsive eye tracking (< 100ms latency)
- [ ] Clear debug visualization
- [ ] Efficient entity management