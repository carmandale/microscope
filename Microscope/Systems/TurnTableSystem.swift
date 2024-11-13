//
//  TurnTableSystem.swift
//  Microscope
//
//  Created by Dale Carman on 11/12/24.
//

import Foundation
import RealityKit
import RealityKitContent

struct TurnTableSystem: System {
    /// A value to check whether the entity has the required component.
    static let query = EntityQuery(where: .has(TurnTableComponent.self))

    /// Initialize the system with the RealityKit scene.
    init(scene: RealityKit.Scene) { }


    func update(context: SceneUpdateContext) {
        for entity in context.entities(matching: Self.query, updatingSystemWhen: .rendering) {
            let comp = entity.components[TurnTableComponent.self]!

            // Apply rotation directly based on `rotationSpeed`
            let angle = comp.rotationSpeed * Float(context.deltaTime)
            let axis = SIMD3<Float>(comp.axisX, comp.axisY, comp.axisZ)
            entity.setOrientation(simd_quatf(angle: angle, axis: axis), relativeTo: entity)
        }
    }
}

