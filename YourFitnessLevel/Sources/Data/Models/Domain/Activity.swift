//
//  Activity.swift
//  YourFitnessLevel
//
//  Created by Eduardo Díaz Estrada on 05.06.21.
//

import Foundation

enum Activity: Equatable {
    case steps([Step])
    case walking
    case running

    var isSteps: Bool {
        guard case .steps = self else { return false }
        return true
    }
}

struct Step: Equatable {
    let date: Date
    let count: Int
}
