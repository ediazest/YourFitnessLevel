//
//  Goal.swift
//  YourFitnessLevel
//
//  Created by Eduardo Díaz Estrada on 03.06.21.
//

import Foundation

struct Goal: Equatable {
    let identifier: String
    let title: String
    let description: String
    let type: GoalType?
    let goal: Int
    let reward: Reward
}

enum GoalType: String {
    case step
    case walking = "walking_distance"
    case running = "running_distance"
}
