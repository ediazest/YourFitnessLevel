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
    
    var image: String {
        switch self {
        case .bronze:
            return "bronzeMedal"
        case .silver:
            return "silverMedal"
        case .gold:
            return "goldMedal"
        case .zombie:
            return "zombieHand"
        }
    }
}
