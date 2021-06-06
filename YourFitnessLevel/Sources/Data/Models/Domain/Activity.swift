//
//  Activity.swift
//  YourFitnessLevel
//
//  Created by Eduardo Díaz Estrada on 05.06.21.
//

import Foundation

enum Activity: Equatable {
    case steps([Value])
    case walking
    case running([Value])

    var isSteps: Bool {
        guard case .steps = self else { return false }
        return true
    }

    var isRunning: Bool {
        guard case .running = self else { return false }
        return true
    }
}

struct Value: Equatable {
    let date: Date
    let count: Int
}
