//
//  AwardsUseCase.swift
//  YourFitnessLevel
//
//  Created by Eduardo Díaz Estrada on 03.06.21.
//

import Combine
import Foundation

protocol AwardsUseCaseProtocol {
    var awards: AnyPublisher<[Goal], Never> { get }

    func fetchAwards()
}

class AwardsUseCase: AwardsUseCaseProtocol {
    @Injected private var goalsRepository: GoalsRepositoryProtocol

    private let awardsSubject = CurrentValueSubject<[Goal], Never>([])
    lazy var awards: AnyPublisher<[Goal], Never> = awardsSubject.eraseToAnyPublisher()

    private var subscriptions: [AnyCancellable] = []

    func fetchAwards() {
        goalsRepository.fetch()
            .sink(
                receiveCompletion: {
                    print($0)
                },
                receiveValue: { [awardsSubject] in
                    awardsSubject.value = $0
                }
            ).store(in: &subscriptions)
    }
}
