//
//  HelpViewStateTests.swift
//  YourFitnessLevelTests
//
//  Created by Eduardo Díaz Estrada on 06.06.21.
//

import Combine
import CombineSchedulers
import XCTest
@testable import YourFitnessLevel

class HelpViewStateTests: XCTestCase {
    private let mockGoalsUseCase = GoalsUseCaseMock()
    private var subscriptions: Set<AnyCancellable> = []

    private var sut: HelpViewState!

    override func setUp() {
        super.setUp()
        createTestDependencies(
            mockGoalsUseCase
        )

        sut = .init(scheduler: .immediate)
    }

    override func tearDown() {
        removeTestDependencies()
        super.tearDown()
    }

    func test_publishesDismissView_onDismissButtonTap() {
        var result: ()?
        sut.dismissPublisher
            .sink(receiveValue: {
                result = $0
            })
            .store(in: &subscriptions)

        sut.handleDismissButtonTap()
        XCTAssertNotNil(result)
    }

    func test_publishesGoalsInViewData() {
        XCTAssertEqual(sut.viewData, .init(goals: []))

        let goals: [Goal] = [.fake()]

        mockGoalsUseCase.goalsSubject.send(goals)

        XCTAssertEqual(mockGoalsUseCase.calls, [])
        XCTAssertEqual(sut.viewData.goals, [
            .init(
                id: goals.first!.identifier,
                title: goals.first!.title,
                description: goals.first!.description,
                points: goals.first!.reward.points,
                image: goals.first!.reward.trophy.image
            )
        ])
    }
}
