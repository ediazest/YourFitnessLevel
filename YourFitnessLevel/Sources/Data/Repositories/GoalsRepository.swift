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

    func fetch() -> AnyPublisher<[Goal], Error> {
        goalsService.fetch()
            .map { [goalsResponseMapper] in
                goalsResponseMapper.map($0)
            }
            .eraseToAnyPublisher()
    }
}
