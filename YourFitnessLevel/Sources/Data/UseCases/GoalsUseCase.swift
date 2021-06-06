//
//  GoalsUseCase.swift
//  YourFitnessLevel
//
//  Created by Eduardo Díaz Estrada on 04.06.21.
//

import Combine
import CombineSchedulers
import Foundation

protocol GoalsUseCaseProtocol {
    var goals: AnyPublisher<[Goal], Never> { get }

    func fetchGoals()
}

class GoalsUseCase: GoalsUseCaseProtocol {
    @Injected private var goalsRepository: GoalsRepositoryProtocol

    private let goalsSubject = CurrentValueSubject<[Goal], Never>([])
    lazy var goals: AnyPublisher<[Goal], Never> = goalsSubject.eraseToAnyPublisher()

    private let scheduler: AnySchedulerOf<DispatchQueue>
    private var subscriptions: [AnyCancellable] = []

    init(scheduler: AnySchedulerOf<DispatchQueue> = .main) {
        self.scheduler = scheduler
    }

    func fetchGoals() {
        goalsRepository.fetch()
            .receive(on: scheduler)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [goalsSubject] in
                    goalsSubject.value = $0
                }
            ).store(in: &subscriptions)
    }
}
