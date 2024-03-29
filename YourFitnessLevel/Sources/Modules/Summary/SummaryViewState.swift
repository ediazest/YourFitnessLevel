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
    @Published var viewData: SummaryViewData = .init()

    @Injected private var activityUseCase: ActivityUseCaseProtocol
    @Injected private var calendar: CalendarProtocol
    @Injected private var dateFormatter: DateFormatterProtocol
    @Injected private var goalsUseCase: GoalsUseCaseProtocol
    @Injected private var storage: UserDefaultStorageProtocol

    private let scheduler: AnySchedulerOf<DispatchQueue>
    private var subscriptions: [AnyCancellable] = []

    private var healthAccessRequestedBefore: Bool {
        (try? storage.get(key: .healthAccessRequested)) == true
    }

    init(scheduler: AnySchedulerOf<DispatchQueue> = .main) {
        self.scheduler = scheduler
        dateFormatter.dateFormat = "E, d MMM"
        viewData = viewData.updated(
            date: dateFormatter.string(from: calendar.currentDate),
            requestedBefore: healthAccessRequestedBefore
        )
    }

    func handleViewAppear() {
        if healthAccessRequestedBefore {
            handleRequestAccessToData()
        }
    }

    func handleRequestAccessToData() {
        Publishers.CombineLatest(
            activityUseCase.todaysActivities,
            goalsUseCase.goals
        )
        .receive(on: scheduler)
        .sink { [handleActivityData] in
            handleActivityData($0, $1)
        }
        .store(in: &subscriptions)

        activityUseCase.fetch()
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
                    generateCategoryData(for: .step, activities.steps, goals.steps),
                    generateCategoryData(for: .running, activities.distance, goals.distance)
                ]
            ),
            requestedBefore: true
        )
    }

    private func generateCategoryData(for goalType: GoalType, _ steps: [Value], _ goals: [Goal]) -> Category {
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
            unit: goalType == .step ? "steps" : "meters",
            title: goalType == .step ? "Daily steps" : "Daily walking distance",
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

    init(
        date: String = "",
        contentType: ContentType = .empty,
        requestedBefore: Bool = false
    ) {
        self.date = date
        self.contentType = contentType
        self.requestedBefore = requestedBefore
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
