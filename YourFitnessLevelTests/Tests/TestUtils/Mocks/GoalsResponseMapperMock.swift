//
//  GoalsResponseMapperMock.swift
//  YourFitnessLevelTests
//
//  Created by Eduardo Díaz Estrada on 03.06.21.
//

import Foundation
@testable import YourFitnessLevel

class GoalsResponseMapperMock: GoalsResponseMapperProtocol {

    enum Call: Equatable {
        case map(GoalResponse)
    }

    var calls: [Call] = []

    var returnedGoals: [[Goal]] = []
    func map(_ source: GoalResponse) -> [Goal] {
        calls.append(.map(source))
        return returnedGoals.popLast() ?? []
    }
}
