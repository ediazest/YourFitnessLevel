//
//  SummaryViewStateTests.swift
//  YourFitnessLevelTests
//
//  Created by Eduardo Díaz Estrada on 06.06.21.
//

import XCTest
@testable import YourFitnessLevel

class SummaryViewStateTests: XCTestCase {
    private let mockActivityUseCase = ActivityUseCaseMock()
    private let mockCalendar = CalendarMock()
    private let mockDateFormatter = DateFormatterMock()
    private let mockGoalsUseCase = GoalsUseCaseMock()
    private let mockStorage = UserDefaultStorageMock()

    var sut: SummaryViewState!

    private let currentDate = "Sun, 6 June"
    private let isRequestedBefore = false

    override func setUp() {
        super.setUp()
        createTestDependencies(
            mockActivityUseCase,
            mockCalendar,
            mockDateFormatter,
            mockGoalsUseCase,
            mockStorage
        )

        mockStorage.returnedValue = isRequestedBefore
        mockDateFormatter.returnedString = currentDate

        sut = .init(scheduler: .immediate)
    }

    override func tearDown() {
        removeTestDependencies()
        super.tearDown()
    }

    func test_updatesViewDataOnInit() {
        XCTAssertEqual(sut.viewData, .init(date: currentDate, contentType: .empty, requestedBefore: isRequestedBefore))
        XCTAssertEqual(mockStorage.calls, [.get("health_requested_key")])
        XCTAssertEqual(mockDateFormatter.calls, [.string(mockCalendar.currentDate)])
    }

    func test_onlyFetchesAutomaticallyData_whenUserWasPromptedBefore() {
        let isRequestedBefore = false

        mockStorage.returnedValue = isRequestedBefore

        sut.handleViewAppear()

        XCTAssertEqual(mockStorage.calls, [.get("health_requested_key"), .get("health_requested_key")])
        XCTAssertEqual(mockActivityUseCase.calls, [])
        XCTAssertEqual(mockGoalsUseCase.calls, [])
    }

    func test_fetchesAutomaticallyData_whenUserWasPromptedBefore() {
        mockStorage.returnedValue = true

        sut.handleViewAppear()

        mockGoalsUseCase.goalsSubject.send([.fake()])
        mockActivityUseCase.activitiesSubject.send([])

        XCTAssertEqual(mockActivityUseCase.calls, [.fetch])
        XCTAssertEqual(sut.viewData, .init(date: currentDate, contentType: .empty, requestedBefore: true))
    }

    func test_presentsEmptyState_whenNoUserActivities() {

        sut.handleRequestAccessToData()

        mockGoalsUseCase.goalsSubject.send([.fake()])
        mockActivityUseCase.activitiesSubject.send([])

        XCTAssertEqual(mockActivityUseCase.calls, [.fetch])
        XCTAssertEqual(sut.viewData, .init(date: currentDate, contentType: .empty, requestedBefore: true))
    }

    func test_presentsUserActivities_goalNotAchieved() {

        let registeredSteps: [Step] = [
            .init(date: Date(), count: 100),
            .init(date: Date(), count: 100),
            .init(date: Date(), count: 100),
            .init(date: Date(), count: 100)

        ]

        let expectedCategories: YourFitnessLevel.Category =
            .init(
                achievedDailyGoals: false,
                currentProgress: 400,
                message: "You still need 400 steps for the next award",
                nextGoal: 800,
                unit: "steps",
                title: "Daily steps",
                samples: registeredSteps.map { .init(date: $0.date, value: Double($0.count)) }
            )

        sut.handleRequestAccessToData()

        mockGoalsUseCase.goalsSubject.send([.fake(type: .step, goal: 800)])
        mockActivityUseCase.activitiesSubject.send([
            .steps(registeredSteps)
        ])

        XCTAssertEqual(mockActivityUseCase.calls, [.fetch])
        XCTAssertEqual(sut.viewData, .init(date: currentDate,
                                           contentType: .data([expectedCategories]),
                                           requestedBefore: true)
        )
    }

    func test_presentsUserActivities_goalAchieved() {

        let registeredSteps: [Step] = [
            .init(date: Date(), count: 100),
            .init(date: Date(), count: 100),
            .init(date: Date(), count: 100),
            .init(date: Date(), count: 100)

        ]

        let expectedCategories: YourFitnessLevel.Category =
            .init(
                achievedDailyGoals: true,
                currentProgress: 400,
                message: "Great job! You already reached your daily goals!🤩",
                nextGoal: 0,
                unit: "steps",
                title: "Daily steps",
                samples: registeredSteps.map { .init(date: $0.date, value: Double($0.count)) }
            )

        sut.handleRequestAccessToData()

        mockGoalsUseCase.goalsSubject.send([.fake(type: .step, goal: 200)])
        mockActivityUseCase.activitiesSubject.send([
            .steps(registeredSteps)
        ])

        XCTAssertEqual(mockActivityUseCase.calls, [.fetch])
        XCTAssertEqual(sut.viewData, .init(date: currentDate,
                                           contentType: .data([expectedCategories]),
                                           requestedBefore: true)
        )
    }
}
