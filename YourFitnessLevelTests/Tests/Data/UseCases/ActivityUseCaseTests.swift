//
//  ActivityUseCaseTests.swift
//  YourFitnessLevelTests
//
//  Created by Eduardo Díaz Estrada on 06.06.21.
//

import Combine
import CombineSchedulers
import XCTest
@testable import YourFitnessLevel

class ActivityUseCaseTests: XCTestCase {
    private let mockHealthDataRepository = HealthDataRepositoryMock()
    private let mockCalendar = CalendarMock()
    private var subscriptions: Set<AnyCancellable> = []

    private var sut: ActivityUseCase!

    override func setUp() {
        super.setUp()
        createTestDependencies(
            mockHealthDataRepository,
            mockCalendar
        )

        sut = .init(scheduler: .immediate)
    }

    override func tearDown() {
        removeTestDependencies()
        super.tearDown()
    }

    func test_empty_whenNoHealthData() {
        let today = Date(timeIntervalSince1970: 1622942421)
        let startOfDay = Date(timeIntervalSince1970: 1622937600)
        let components: DateComponents = .init(year: 2021, month: 6)
        let dateFromComponents = Date(timeIntervalSince1970: 1622942421)

        mockCalendar.currentDate = today
        mockCalendar.startOfDay = startOfDay
        mockCalendar.returnedDateComponents = components
        mockCalendar.returnedDate = dateFromComponents

        var currentDaySteps: [Activity]?
        var currentMonthSteps: Activity?

        sut.activities.sink {
            currentDaySteps = $0
        }.store(in: &subscriptions)

        sut.runningMonthSteps.sink {
            currentMonthSteps = $0
        }.store(in: &subscriptions)

        sut.fetch()

        mockHealthDataRepository.activitySubject.send(completion: .failure(MockError.some))

        XCTAssertEqual(mockHealthDataRepository.calls, [
            .fetch(startOfDay, today, 30, .steps),
            .fetch(dateFromComponents, today, 60 * 24, .steps)
        ])

        XCTAssertEqual(mockCalendar.calls, [
            .startOfDay(today),
            .dateComponents([.month, .year], today),
            .date(.init(year: 2021, month: 6, day: 1, hour: 0, minute: 0))
        ])

        XCTAssertEqual(currentDaySteps, [])
        XCTAssertNil(currentMonthSteps)
    }

    func test_forwardsValues_whenValidHealthData() {
        let today = Date(timeIntervalSince1970: 1622942421)
        let startOfDay = Date(timeIntervalSince1970: 1622937600)
        let components: DateComponents = .init(year: 2021, month: 6)
        let dateFromComponents = Date(timeIntervalSince1970: 1622942421)

        mockCalendar.currentDate = today
        mockCalendar.startOfDay = startOfDay
        mockCalendar.returnedDateComponents = components
        mockCalendar.returnedDate = dateFromComponents

        var currentDaySteps: [Activity]?
        var currentMonthSteps: Activity?

        let expectedActivity: Activity = .steps([
            .init(date: today, count: 30),
            .init(date: today, count: 55),
            .init(date: today, count: 255)
        ])

        sut.activities.sink {
            currentDaySteps = $0
        }.store(in: &subscriptions)

        sut.runningMonthSteps.sink {
            currentMonthSteps = $0
        }.store(in: &subscriptions)

        sut.fetch()

        mockHealthDataRepository.activitySubject.send(expectedActivity)

        XCTAssertEqual(mockHealthDataRepository.calls, [
            .fetch(startOfDay, today, 30, .steps),
            .fetch(dateFromComponents, today, 60 * 24, .steps)
        ])

        XCTAssertEqual(mockCalendar.calls, [
            .startOfDay(today),
            .dateComponents([.month, .year], today),
            .date(.init(year: 2021, month: 6, day: 1, hour: 0, minute: 0))
        ])

        XCTAssertEqual(currentDaySteps, [expectedActivity])
        XCTAssertEqual(currentMonthSteps, expectedActivity)
    }
}
