//
//  GoalsRepository.swift
//  YourFitnessLevel
//
//  Created by Eduardo Díaz Estrada on 03.06.21.
//

import Combine
import Foundation

protocol GoalsRepositoryProtocol {
    func fetch() -> AnyPublisher<[Goal], Error>
}

class GoalsRepository: GoalsRepositoryProtocol {
    @Injected private var goalsService: GoalsServiceProtocol
    @Injected private var userDefaultStorage: UserDefaultStorageProtocol
    @Injected private var goalsResponseMapper: GoalsResponseMapperProtocol

    private var localGoalsPublisher: AnyPublisher<[Goal], Error> {
        DeferredFuture<[Goal], Error> { [userDefaultStorage, goalsResponseMapper] promise in
            do {
                guard let stored: GoalResponse = try userDefaultStorage.get(key: .goalsKey) else {
                    promise(.success([]))
                    return
                }
                promise(.success(goalsResponseMapper.map(stored)))
            } catch {
                debugPrint(error)
                promise(.success([]))
            }
        }.eraseToAnyPublisher()
    }

    private var remoteGoalsPublisher: AnyPublisher<[Goal], Error> {
        goalsService.fetch()
           .handleEvents(receiveOutput: { [userDefaultStorage] in
               try? userDefaultStorage.set(value: $0, key: .goalsKey)
           })
           .map { [goalsResponseMapper] in goalsResponseMapper.map($0) }
           .eraseToAnyPublisher()
    }

    func fetch() -> AnyPublisher<[Goal], Error> {
        Publishers.Concatenate(
            prefix: localGoalsPublisher,
            suffix: remoteGoalsPublisher
        ).eraseToAnyPublisher()
    }
}

private extension String {
    static let goalsKey: Self = "goals_key"
}
