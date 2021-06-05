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
    @Published var viewData: SummaryViewData = .init(
        date: "",
        contentType: .empty,
        requestedBefore: false
        )

    @Injected private var activityUseCase: ActivityUseCaseProtocol
    @Injected private var calendar: CalendarProtocol
    @Injected private var dateFormatter: DateFormatterProtocol
    @Injected private var goalsUseCase: GoalsUseCaseProtocol

    private let scheduler: AnySchedulerOf<DispatchQueue>
    private var subscriptions: [AnyCancellable] = []

    init(scheduler: AnySchedulerOf<DispatchQueue> = .main) {
        self.scheduler = scheduler
        dateFormatter.dateFormat = "E, d MMM"
        viewData = viewData.updated(
            date: dateFormatter.string(from: calendar.currentDate),
            requestedBefore: false
        )
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
        guard !activities.isEmpty else {
            viewData = viewData.updated(
                contentType: .empty,
                requestedBefore: true
            )
            return
        }

        viewData = viewData.updated(
            contentType: .data(
                [
                    generateStepsData(activities, goals: goals)
                ]
            ),
            requestedBefore: true
        )
    }

    private func generateStepsData(_ activities: [Activity], goals: [Goal]) -> Category {
        let steps = activities
            .filter { $0.isSteps }
            .flatMap { activity -> [Step] in
                if case let .steps(steps) = activity { return steps }
                return []
            }

        let currentProgress = steps.sum
        let nextGoal = goals
            .map { $0.goal }
            .first(where: { $0 > currentProgress }) ?? 0

        let achievedDailyGoals = currentProgress > nextGoal

        return .init(
            achievedDailyGoals: achievedDailyGoals,
            currentProgress: currentProgress,
            message: message(currentProgress: currentProgress, nextGoal: nextGoal),
            nextGoal: nextGoal,
            unit: "steps",
            title: "Daily steps",
            samples: steps.map { .init(date: $0.date, value: Double($0.count)) }
        )
    }

    private func message(currentProgress: Int, nextGoal: Int) -> String {
        if nextGoal > currentProgress {
            return "You still need \(nextGoal - currentProgress) steps for the next award"
        } else {
            return "Great job! You already reached your daily goals!🤩"
        }
    }
}

struct SummaryViewData: Equatable {
    let date: String
    let contentType: ContentType
    let requestedBefore: Bool

    enum ContentType: Equatable {
        case empty
        case data([Category])
    }

    func updated(
        date: String? = nil,
        contentType: ContentType? = nil,
        requestedBefore: Bool? = nil
    ) -> Self {
        .init(
            date: date ?? self.date,
            contentType: contentType ?? self.contentType,
            requestedBefore: requestedBefore ?? self.requestedBefore
        )
    }
}

private extension Array where Element == Step {
    var sum: Int {
        self.map { $0.count }
            .reduce(0, +)
    }
}
