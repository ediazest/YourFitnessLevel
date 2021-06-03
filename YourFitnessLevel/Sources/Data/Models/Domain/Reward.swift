//
//  Reward.swift
//  YourFitnessLevel
//
//  Created by Eduardo Díaz Estrada on 03.06.21.
//

import Foundation

struct Reward: Equatable {
    let trophy: Trophy?
    let points: Int
}

enum Trophy: String {
    case bronze = "bronze_medal"
    case silver = "silver_medal"
    case gold = "gold_medal"
    case zombie = "zombie_hand"
}
