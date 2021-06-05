//
//  AwardsViewState.swift
//  YourFitnessLevel
//
//  Created by Eduardo Díaz Estrada on 04.06.21.
//

import Combine
import CombineSchedulers
import Foundation

class AwardsViewState: ObservableObject {
    @Injected private var activityUseCase: ActivityUseCaseProtocol
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
        Publishers.CombineLatest(
            activityUseCase.runningMonthSteps,
            goalsUseCase.goals
        )
        .receive(on: scheduler)
        .sink { [handleReceivedData] in
            handleReceivedData($0, $1)
        }
        .store(in: &subscriptions)
    }

    private func handleReceivedData(activity: Activity?, goals: [Goal]) {
        let awards = goals
            .map { goal -> AwardsViewData.Award in
                .init(
                    id: UUID().uuidString,
                    image: goal.reward.trophy.image,
                    title: goal.title,
                    detail: goal.reward.trophy.title,
                    achieved: calculateUserTrophies(goal: goal, activities: [activity]))
            }

        let points = goals
            .map { calculateUserPoints(goal: $0, activities: [activity]) }
            .reduce(0, +)

        viewData = .init(
            points: points,
            shouldDisplayHelpButton: !awards.isEmpty,
            awards: awards
        )
    }

    private func calculateUserPoints(goal: Goal, activities: [Activity?]) -> Int {
        if goal.type == .step {
            let steps = activities
                .compactMap { $0 }
                .filter { $0.isSteps }
                .flatMap { activity -> [Step] in
                    if case let .steps(steps) = activity { return steps }
                    return []
                }
            guard !steps.isEmpty else { return 0 }

            return steps.sum > goal.goal ? goal.reward.points : 0
        } else {
            return 0
        }
    }

    private func calculateUserTrophies(goal: Goal, activities: [Activity?]) -> Int {
        if goal.type == .step {
            let steps = activities
                .compactMap { $0 }
                .filter { $0.isSteps }
                .flatMap { activity -> [Step] in
                    if case let .steps(steps) = activity { return steps }
                    return []
                }
            guard !steps.isEmpty else { return 0 }

            return steps.sum > goal.goal ? 1 : 0
        } else {
            return 0
        }
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
        let image: String
        let title: String
        let detail: String
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
