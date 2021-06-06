//
//  GoalsServiceMock.swift
//  YourFitnessLevelTests
//
//  Created by Eduardo Díaz Estrada on 06.06.21.
//

import Combine
import CombineSchedulers
import Foundation
@testable import YourFitnessLevel

class GoalsServiceMock: GoalsServiceProtocol {
    enum Call: Equatable {
        case fetch
    }

    var calls: [Call] = []

    var goalResponseSubject = PassthroughSubject<GoalResponse, Error>()
    func fetch() -> AnyPublisher<GoalResponse, Error> {
        calls.append(.fetch)
        return goalResponseSubject.testable
    }
}
