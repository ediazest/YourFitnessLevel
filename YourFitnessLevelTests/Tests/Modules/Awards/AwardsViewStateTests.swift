//
//  AwardsViewStateTests.swift
//  YourFitnessLevelTests
//
//  Created by Eduardo Díaz Estrada on 06.06.21.
//

import Combine
import Foundation
import XCTest
@testable import YourFitnessLevel

class AwardsViewStateTests: XCTestCase {
    private let mockGoalsUseCase = GoalsUseCaseMock()
    private let mockActivityUseCase = ActivityUseCaseMock()

    private var sut: AwardsViewState!

    override func setUp() {
        super.setUp()
        createTestDependencies(
            mockGoalsUseCase,
            mockActivityUseCase
        )

        sut = .init(scheduler: .immediate)
    }

    override func tearDown() {
        removeTestDependencies()
        super.tearDown()
    }

    func test_presentsHelp_onHelpButtonTap() {
        XCTAssertFalse(sut.presentHelp)
        sut.handleHelpButtonTap()
        XCTAssertTrue(sut.presentHelp)
    }

    func test_hidesAwardInformation_whenNoGoalsAvailable() {
        let goals: [Goal] = []

        mockActivityUseCase.runningMonthStepsSubject.send([])
        mockGoalsUseCase.goalsSubject.send(goals)

        XCTAssertEqual(sut.viewData, .init(points: 0, shouldDisplayHelpButton: false, awards: []))
    }

    func test_displaysAwardInformation_whenNoActivityAvailable() {
        let goals: [Goal] = [
            .fake(),
            .fake()
        ]

        mockActivityUseCase.runningMonthStepsSubject.send([])
        mockGoalsUseCase.goalsSubject.send(goals)

        XCTAssertEqual(sut.viewData, .init(
                        points: 0,
                        shouldDisplayHelpButton: true,
                        awards: [
                            .init(id: goals[0].identifier,
                                  image: goals[0].reward.trophy.image,
                                  title: goals[0].title,
                                  detail: goals[0].reward.trophy.title,
                                  achieved: 0
                            ),
                            .init(id: goals[1].identifier,
                                  image: goals[1].reward.trophy.image,
                                  title: goals[1].title,
                                  detail: goals[1].reward.trophy.title,
                                  achieved: 0
                            )
                        ])
        )
    }

    func test_displaysAwardInformation_whenActivityAvailable_withPointCalculation() {
        let activity: Activity = .steps([
            .init(date: Date(), count: 6000),
            .init(date: Date(), count: 2000)
        ])
        let goals: [Goal] = [
            .fake(goal: 1000, points: 10),
            .fake(goal: 5000, points: 50)
        ]

        mockActivityUseCase.runningMonthStepsSubject.send([activity])
        mockGoalsUseCase.goalsSubject.send(goals)

        XCTAssertEqual(sut.viewData, .init(
                        points: 70,
                        shouldDisplayHelpButton: true,
                        awards: [
                            .init(id: goals[0].identifier,
                                  image: goals[0].reward.trophy.image,
                                  title: goals[0].title,
                                  detail: goals[0].reward.trophy.title,
                                  achieved: 2
                            ),
                            .init(id: goals[1].identifier,
                                  image: goals[1].reward.trophy.image,
                                  title: goals[1].title,
                                  detail: goals[1].reward.trophy.title,
                                  achieved: 1
                            )
                        ])
        )
    }
}
