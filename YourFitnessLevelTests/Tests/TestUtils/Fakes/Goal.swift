//
//  Goal.swift
//  YourFitnessLevelTests
//
//  Created by Eduardo Díaz Estrada on 06.06.21.
//

import Foundation
@testable import YourFitnessLevel

extension Goal {
    static func fake(
        identifier: String = UUID().uuidString,
        title: String = UUID().uuidString,
        description: String = UUID().uuidString,
        type: GoalType? = GoalType.step,
        goal: Int = Int.random(in: 0..<100),
        trophy: Trophy = .bronze,
        points: Int = Int.random(in: 0..<50)
    ) -> Self {
        .init(
            identifier: identifier,
            title: title,
            description: description,
            type: type,
            goal: goal,
            reward: .init(trophy: trophy, points: points)
        )
    }
}
