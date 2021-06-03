//
//  GoalsResponseMapper.swift
//  YourFitnessLevel
//
//  Created by Eduardo Díaz Estrada on 03.06.21.
//

import Foundation

protocol GoalsResponseMapperProtocol {
    func map(_ source: GoalResponse) -> [Goal]
}

class GoalsResponseMapper: GoalsResponseMapperProtocol {
    func map(_ source: GoalResponse) -> [Goal] {
        source.items.map {
            Goal(
                identifier: $0.identifier,
                title: $0.title,
                description: $0.description,
                type: .init(rawValue: $0.type),
                goal: $0.goal,
                reward: .init(
                    trophy: .init(rawValue: $0.reward.trophy),
                    points: $0.reward.points
                )
            )
        }
    }
}
