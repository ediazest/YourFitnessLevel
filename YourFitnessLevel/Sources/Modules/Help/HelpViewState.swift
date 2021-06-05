//
//  HelpViewState.swift
//  YourFitnessLevel
//
//  Created by Eduardo Díaz Estrada on 05.06.21.
//

import Combine
import CombineSchedulers
import Foundation

class HelpViewState: ObservableObject {
    @Injected private var goalsUseCase: GoalsUseCaseProtocol

    @Published var viewData: HelpViewData = .init(goals: [])

    private let dismissSubject = PassthroughSubject<Void, Never>()
    lazy var dismissPublisher: AnyPublisher<Void, Never> = dismissSubject.eraseToAnyPublisher()

    private let scheduler: AnySchedulerOf<DispatchQueue>
    private var subscriptions: [AnyCancellable] = []

    init(scheduler: AnySchedulerOf<DispatchQueue> = .main) {
        self.scheduler = scheduler
        configureSubscriptions()
    }

    func handleDismissButtonTap() {
        dismissSubject.send()
    }

    private func configureSubscriptions() {
        goalsUseCase.goals
            .receive(on: scheduler)
            .sink { [handleGoals] in
                handleGoals($0)
            }
            .store(in: &subscriptions)
    }

    private func handleGoals(_ goals: [Goal]) {
        viewData = .init(
            goals: goals.map {
                .init(
                    id: $0.identifier,
                    title: $0.title,
                    description: $0.description,
                    points: $0.reward.points,
                    image: $0.reward.trophy?.image ?? ""
                )
            }
        )
    }
}

struct HelpViewData: Equatable {
    let goals: [Goal]

    struct Goal: Equatable, Identifiable {
        let id: String
        let title: String
        let description: String
        let points: Int
        let image: String
    }
}
