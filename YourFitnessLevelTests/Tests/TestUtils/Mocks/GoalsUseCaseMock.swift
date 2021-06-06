//
//  GoalsUseCaseMock.swift
//  YourFitnessLevelTests
//
//  Created by Eduardo Díaz Estrada on 06.06.21.
//

import Combine
@testable import YourFitnessLevel

class GoalsUseCaseMock: GoalsUseCaseProtocol {
    enum Call: Equatable {
        case fetch
    }

    var calls: [Call] = []

    let goalsSubject = PassthroughSubject<[Goal], Never>()
    lazy var goals: AnyPublisher<[Goal], Never> = goalsSubject.testable

    func fetchGoals() {
        calls.append(.fetch)
    }
}
