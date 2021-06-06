//
//  ActivityUseCase.swift
//  YourFitnessLevel
//
//  Created by Eduardo Díaz Estrada on 05.06.21.
//

import Combine
import CombineSchedulers
import Foundation

protocol ActivityUseCaseProtocol {
    var activities: AnyPublisher<[Activity], Never> { get }
    var runningMonthSteps: AnyPublisher<Activity?, Never> { get }

    func fetch()
}

class ActivityUseCase: ActivityUseCaseProtocol {
    @Injected private var healthDataRepository: HealthDataRepositoryProtocol
    @Injected private var calendar: CalendarProtocol

    private let activitiesSubject = CurrentValueSubject<[Activity], Never>([])
    lazy var activities: AnyPublisher<[Activity], Never> = activitiesSubject.eraseToAnyPublisher()

    private let runningMonthStepsSubject = CurrentValueSubject<Activity?, Never>(nil)
    lazy var runningMonthSteps: AnyPublisher<Activity?, Never> = runningMonthStepsSubject
        .eraseToAnyPublisher()

    private let scheduler: AnySchedulerOf<DispatchQueue>
    private var subscriptions: [AnyCancellable] = []

    init(scheduler: AnySchedulerOf<DispatchQueue> = .main) {
        self.scheduler = scheduler
    }

    func fetch() {
        fetchTodaysSteps()
        fetchMonthSteps()
    }

    private func fetchTodaysSteps() {
        healthDataRepository.fetchActivityData(
            startDate: calendar.startOfDay(for: calendar.currentDate),
            endDate: calendar.currentDate,
            intervalInMinutes: .twicePerHour,
            type: .steps
        )
        .handleEvents(receiveOutput: {[activitiesSubject] in
            activitiesSubject.send([$0])
        })
        .subscribe()
        .store(in: &subscriptions)
    }

    private func fetchMonthSteps() {
        var sameMonthComponents = calendar.dateComponents([.month, .year], from: calendar.currentDate)
        sameMonthComponents.day = 1
        sameMonthComponents.hour = 0
        sameMonthComponents.minute = 0

        healthDataRepository.fetchActivityData(
            startDate: calendar.date(from: sameMonthComponents) ?? calendar.currentDate,
            endDate: calendar.currentDate,
            intervalInMinutes: .oncePerDay,
            type: .steps
        )
        .handleEvents(receiveOutput: {[runningMonthStepsSubject] in
            runningMonthStepsSubject.send($0)
        })
        .subscribe()
        .store(in: &subscriptions)
    }
}

private extension Int {
    static let twicePerHour: Self = 30
    static let oncePerDay: Self = 60 * 24
}
