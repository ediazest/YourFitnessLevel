//
//  GoalsUseCase.swift
//  YourFitnessLevel
//
//  Created by Eduardo Díaz Estrada on 04.06.21.
//

import Combine
import Foundation

protocol GoalsUseCaseProtocol {
    var goals: AnyPublisher<[Goal], Never> { get }

    func fetchGoals()
}

class GoalsUseCase: GoalsUseCaseProtocol {
    @Injected private var goalsRepository: GoalsRepositoryProtocol

    private let goalsSubject = CurrentValueSubject<[Goal], Never>([])
    lazy var goals: AnyPublisher<[Goal], Never> = goalsSubject.eraseToAnyPublisher()

    private var subscriptions: [AnyCancellable] = []

    func fetchGoals() {
        goalsRepository.fetch()
            .sink(
                receiveCompletion: {
                    print($0)
                },
                receiveValue: { [goalsSubject] in
                    goalsSubject.value = $0
                }
            ).store(in: &subscriptions)
    }
}
