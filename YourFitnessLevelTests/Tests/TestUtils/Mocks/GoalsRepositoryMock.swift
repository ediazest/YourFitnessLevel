//
//  GoalsRepositoryMock.swift
//  YourFitnessLevelTests
//
//  Created by Eduardo Díaz Estrada on 06.06.21.
//

import Combine
import Foundation
@testable import YourFitnessLevel

class GoalsRepositoryMock: GoalsRepositoryProtocol {
    enum Call: Equatable {
        case fetch
    }

    var calls: [Call] = []

    var fetchSubject = PassthroughSubject<[Goal], Error>()
    func fetch() -> AnyPublisher<[Goal], Error> {
        calls.append(.fetch)
        return fetchSubject.testable
    }
}
