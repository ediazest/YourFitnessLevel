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
            activityUseCase.runningMonthActivities,
            goalsUseCase.goals
        )
        .receive(on: scheduler)
        .sink { [handleReceivedData] in
            handleReceivedData($0, $1)
        }
        .store(in: &subscriptions)
    }

    private func handleReceivedData(activities: [Activity], goals: [Goal]) {
        let awards = goals
            .map { goal -> AwardsViewData.Award in
                .init(
                    id: goal.identifier,
                    image: goal.reward.trophy.image,
                    title: goal.title,
                    detail: goal.reward.trophy.title,
                    achieved: calculateUserTrophies(goal: goal, activities: activities))
            }

        let points = goals
            .map { calculateUserPoints(goal: $0, activities: activities) }
            .reduce(0, +)

        viewData = .init(
            points: points,
            shouldDisplayHelpButton: !awards.isEmpty,
            awards: awards
        )
    }

    private func calculateUserPoints(goal: Goal, activities: [Activity]) -> Int {
        let steps = goal.type == .step ? activities.steps : activities.distance

        guard !steps.isEmpty else { return 0 }

        return steps.map { $0.count }
            .filter { $0 > goal.goal }
            .map { _ in goal.reward.points }
            .reduce(0, +)
    }

    private func calculateUserTrophies(goal: Goal, activities: [Activity]) -> Int {
        let steps = goal.type == .step ? activities.steps : activities.distance

        guard !steps.isEmpty else { return 0 }

        return steps.map { $0.count }
            .filter { $0 > goal.goal }
            .map { _ in 1 }
            .reduce(0, +)
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
