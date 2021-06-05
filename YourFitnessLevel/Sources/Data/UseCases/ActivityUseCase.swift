//
//  ActivityUseCase.swift
//  YourFitnessLevel
//
//  Created by Eduardo Díaz Estrada on 05.06.21.
//

import Combine
import Foundation

protocol ActivityUseCaseProtocol {
    var activities: AnyPublisher<[Activity], Never> { get }
    func fetch()

    var runningMonthSteps: AnyPublisher<Activity?, Never> { get }
}

class ActivityUseCase: ActivityUseCaseProtocol {
    @Injected private var healthDataRepository: HealthDataRepositoryProtocol
    @Injected private var calendar: CalendarProtocol

    private let activitiesSubject = CurrentValueSubject<[Activity], Never>([])
    lazy var activities: AnyPublisher<[Activity], Never> = activitiesSubject.eraseToAnyPublisher()

    private let runningMonthStepsSubject = CurrentValueSubject<Activity?, Never>(nil)
    lazy var runningMonthSteps: AnyPublisher<Activity?, Never> = runningMonthStepsSubject
        .eraseToAnyPublisher()

    private var subscriptions: [AnyCancellable] = []

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
        .handleEvents(receiveOutput: {[update] in
            update($0)
        })
        .map { _ in Void() }
        .sink(receiveCompletion: {
            print($0)
        }, receiveValue: {})
        .store(in: &subscriptions)
    }

    private func fetchMonthSteps() {
        healthDataRepository.fetchActivityData(
            startDate: calendar.startOfDay(for: calendar.currentDate),
            endDate: calendar.currentDate,
            intervalInMinutes: .twicePerHour,
            type: .steps
        )
        .handleEvents(receiveOutput: {[runningMonthStepsSubject] in
            runningMonthStepsSubject.send($0)
        })
        .map { _ in Void() }
        .sink(receiveCompletion: {
            print($0)
        }, receiveValue: {})
        .store(in: &subscriptions)
    }

    private func update(_ activity: Activity) {
        activitiesSubject.send([activity])
    }
}

private extension Int {
    static let twicePerHour: Self = 30
}
