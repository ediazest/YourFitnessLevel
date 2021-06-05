//
//  SummaryViewState.swift
//  YourFitnessLevel
//
//  Created by Eduardo Díaz Estrada on 02.06.21.
//

import Combine
import CombineSchedulers
import Foundation

class SummaryViewState: ObservableObject {
    @Published var viewData: SummaryViewData = .init(date: "Wed 2, June", contentType: .empty)

    @Injected private var activityUseCase: ActivityUseCaseProtocol
    @Injected private var goalsUseCase: GoalsUseCaseProtocol

    private let scheduler: AnySchedulerOf<DispatchQueue>
    private var subscriptions: [AnyCancellable] = []

    init(scheduler: AnySchedulerOf<DispatchQueue> = .main) {
        self.scheduler = scheduler
    }

    func handleViewAppear() {
        activityUseCase.fetch()
    }

    func handleRequestAccessToData() {
        Publishers.CombineLatest(
            activityUseCase.activities,
            goalsUseCase.goals
        )
        .receive(on: scheduler)
        .sink { [handleActivityData] in
            handleActivityData($0, $1)
        }
        .store(in: &subscriptions)
    }

    private func handleActivityData(activities: [Activity], goals: [Goal]) {
        let date = "Wed 5, June"

        viewData = .init(
            date: date,
            contentType: .data(
                [
                    generateStepsData(activities, goals: goals)
                ]
            )
        )
    }

    private func generateStepsData(_ activities: [Activity], goals: [Goal]) -> Category {
        let steps = activities
            .filter { $0.isSteps }
            .flatMap { activity -> [Step] in
                if case let .steps(steps) = activity { return steps }
                return []
            }

        let nextGoal = goals
            .map { $0.goal }
            .first(where: { $0 > steps.sum }) ?? 0

        let achievedDailyGoals = steps.sum > nextGoal

        return .init(
            achievedDailyGoals: achievedDailyGoals,
            currentProgress: steps.sum,
            nextGoal: nextGoal,
            title: "Daily steps"
        )
    }
}

struct SummaryViewData: Equatable {
    let date: String
    let contentType: ContentType

    enum ContentType: Equatable {
        case empty
        case data([Category])
    }
}

private extension Array where Element == Step {
    var sum: Int {
        self.map { $0.count }
            .reduce(0, +)
    }
}
