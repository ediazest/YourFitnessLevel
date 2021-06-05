//
//  AwardsViewState.swift
//  YourFitnessLevel
//
//  Created by Eduardo Díaz Estrada on 04.06.21.
//

import Combine
import CombineSchedulers
import Foundation
import UIKit

class AwardsViewState: ObservableObject {
    @Injected private var goalsUseCase: GoalsUseCaseProtocol

    @Published var viewData: AwardsViewData = .init()
    @Published var presentHelp: Bool = false

    private let scheduler: AnySchedulerOf<DispatchQueue>
    private var subscriptions: [AnyCancellable] = []

    init(scheduler: AnySchedulerOf<DispatchQueue> = .main) {
        self.scheduler = scheduler
        configureSubscriptions()
    }

    func handleHelpButtonTap() {
        presentHelp = true
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
        let awards = goals
            .compactMap { $0.reward.trophy }
            .removingDuplicates()
            .map { trophy -> AwardsViewData.Award in
                switch trophy {
                case .bronze:
                    return AwardsViewData.Award(
                        id: trophy.rawValue,
                        image: .bronzeMedal,
                        title: trophy.title,
                        achieved: 0)
                case .silver:
                    return AwardsViewData.Award(
                        id: trophy.rawValue,
                        image: .silverMedal,
                        title: trophy.title,
                        achieved: 0)
                case .gold:
                    return AwardsViewData.Award(
                        id: trophy.rawValue,
                        image: .goldMedal,
                        title: trophy.title,
                        achieved: 0)
                case .zombie:
                    return AwardsViewData.Award(
                        id: trophy.rawValue,
                        image: .zombieHand,
                        title: trophy.title,
                        achieved: 0)
                }
            }

        viewData = .init(
            points: 0,
            shouldDisplayHelpButton: !awards.isEmpty,
            awards: awards
        )
    }
}

struct AwardsViewData: Equatable {
    let points: Int
    let shouldDisplayHelpButton: Bool
    let awards: [Award]

    init(
        points: Int = 0,
        shouldDisplayHelpButton: Bool = false,
        awards: [Award] = []
    ) {
        self.points = points
        self.shouldDisplayHelpButton = shouldDisplayHelpButton
        self.awards = awards
    }

    struct Award: Equatable {
        let id: String
        let image: UIImage
        let title: String
        let achieved: Int
    }
}

private extension Trophy {
    var title: String {
        switch self {
        case .bronze:
            return "Bronze"
        case .silver:
            return "Silver"
        case .gold:
            return "Gold"
        case .zombie:
            return "Zombie"
        }
    }
}
