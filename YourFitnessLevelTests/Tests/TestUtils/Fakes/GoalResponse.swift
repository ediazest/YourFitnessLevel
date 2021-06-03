//
//  GoalResponse.swift
//  YourFitnessLevelTests
//
//  Created by Eduardo Díaz Estrada on 03.06.21.
//

import Foundation
@testable import YourFitnessLevel

extension GoalResponse {
    static func fake(_ items: [GoalDTO]) -> Self {
        .init(
            items: items,
            nextPageToken: "some"
        )
    }
}

extension GoalDTO {
    static func fake(
        identifier: String = UUID().uuidString,
        title: String = "Peak",
        description: String = "climb Everest",
        type: String = "some",
        goal: Int = Int.random(in: 0..<50),
        trophy: String = "bronze",
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
