//
//  BreathSystem.swift
//  testModel
//
//  Created by Dale Carman on 10/24/24.
//


import Foundation
import RealityKit
import RealityKitContent

// This was used by Lab 010 to learn my way around components and systems
class BreathSystem: System {

    // Define a query to return all entities with a BreathComponent.
    private static let query = EntityQuery(where: .has(BreathComponent.self))

    // Configuration for breathing effect
    private struct BreathConfig {
        static let baseScale: Float = 1.0          // Base scale of the entity
        static let scaleIntensity: Float = 0.05    // Reduced intensity for subtlety
        static let minScale: Float = 0.95          // Minimum scale
        static let maxScale: Float = 1.05          // Maximum scale
    }

    // init is required even when not used
    required init(scene: Scene) {
        // Perform required initialization or setup.
    }

    // Track accumulated time per entity - this will break if we have a dymaic number of entities
    var accumulatedTime: [Entity: Float] = [:]

    func update(context: SceneUpdateContext) {
        for entity in context.entities(
            matching: Self.query,
            updatingSystemWhen: .rendering
        ) {
            guard let breath = entity.components[BreathComponent.self] else { continue }

            let duration = breath.duration
            let deltaTime = Float(context.deltaTime)

            // Update accumulated time
            accumulatedTime[entity, default: 0.0] += deltaTime

            // Use a smoother sine wave calculation
            let normalizedTime = accumulatedTime[entity]! / duration
            let angle = normalizedTime * 2.0 * .pi

            // Use sine for smooth oscillation
            let oscillation = sin(angle)

            // Calculate the scale factor with smoother interpolation
            let scale = BreathConfig.baseScale + (oscillation * BreathConfig.scaleIntensity)

            // Apply the scale uniformly
            entity.transform.scale = SIMD3(repeating: scale)

            // Wrap the time instead of resetting to avoid discontinuity
            if accumulatedTime[entity]! >= duration {
                accumulatedTime[entity]! -= duration
            }
        }
    }
}

// Helper extension to clamp values
extension Float {
    func clamp(min: Float, max: Float) -> Float {
        return Swift.min(Swift.max(self, min), max)
    }
}