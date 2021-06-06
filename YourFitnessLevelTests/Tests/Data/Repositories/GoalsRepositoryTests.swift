//
//  GoalsRepositoryTests.swift
//  YourFitnessLevelTests
//
//  Created by Eduardo Díaz Estrada on 03.06.21.
//

import Combine
import Foundation
@testable import YourFitnessLevel
import XCTest

class GoalsRepositoryTests: XCTestCase {
    private let mockGoalsService = GoalsServiceMock()
    private let mockStorage = UserDefaultStorageMock()
    private let mockGoalsResponseMapper = GoalsResponseMapperMock()

    private var sut: GoalsRepository!

    private var subscriptions: Set<AnyCancellable> = []

    override func setUp() {
        super.setUp()
        createTestDependencies(
            mockGoalsService,
            mockStorage,
            mockGoalsResponseMapper
        )

        sut = .init()
    }

    override func tearDown() {
        removeTestDependencies()
        super.tearDown()
    }

    func test_fetch_onlyRemote_whenNoLocal() {
        let localGoals: [Goal] = []
        let remoteGoalResponse: GoalResponse = .fake([])
        let remoteGoals: [Goal] = [.fake()]

        mockStorage.returnedValue = nil

        var result: [[Goal]] = []

        sut.fetch()
            .sink(
                receiveCompletion: {
                    guard case .finished = $0 else {
                        XCTFail("It should not fail")
                        return
                    }
                },
                receiveValue: {
                    result.append($0)
                }
            )
            .store(in: &subscriptions)

        mockGoalsResponseMapper.returnedGoals = [remoteGoals]
        mockGoalsService.goalResponseSubject.send(remoteGoalResponse)

        XCTAssertEqual(result, [localGoals, remoteGoals])
        XCTAssertEqual(mockGoalsService.calls, [.fetch])
        XCTAssertEqual(mockGoalsResponseMapper.calls, [.map(remoteGoalResponse)])
        XCTAssertEqual(
            mockStorage.calls, [
                .get("goals_key"),
                .set("goals_key")
            ]
        )
    }

    func test_fetch_localFirst_thenRemote() {
        let localGoals: [Goal] = [.fake()]
        let remoteGoalResponse: GoalResponse = .fake([])
        let remoteGoals: [Goal] = [.fake()]

        mockGoalsResponseMapper.returnedGoals = [remoteGoals, localGoals]
        mockStorage.returnedValue = remoteGoalResponse

        var result: [[Goal]] = []

        sut.fetch()
            .sink(
                receiveCompletion: {
                    guard case .finished = $0 else {
                        XCTFail("It should not fail")
                        return
                    }
                },
                receiveValue: {
                    result.append($0)
                }
            )
            .store(in: &subscriptions)

        mockGoalsService.goalResponseSubject.send(remoteGoalResponse)

        XCTAssertEqual(result, [localGoals, remoteGoals])
        XCTAssertEqual(mockGoalsService.calls, [.fetch])
        XCTAssertEqual(mockGoalsResponseMapper.calls, [.map(remoteGoalResponse),
                                                       .map(remoteGoalResponse)])
        XCTAssertEqual(
            mockStorage.calls, [
                .get("goals_key"),
                .set("goals_key")
            ]
        )
    }

    func test_fetch_localFirst_andErrorDuringRemote_publishesLocalAgain() {
        let localGoals: [Goal] = [.fake()]
        let remoteGoalResponse: GoalResponse = .fake([])

        mockGoalsResponseMapper.returnedGoals = [localGoals, localGoals]
        mockStorage.returnedValue = remoteGoalResponse

        var result: [[Goal]] = []

        sut.fetch()
            .sink(
                receiveCompletion: {
                    guard case .finished = $0 else {
                        XCTFail("It should not fail")
                        return
                    }
                },
                receiveValue: {
                    result.append($0)
                }
            )
            .store(in: &subscriptions)

        mockGoalsService.goalResponseSubject.send(completion: .failure(MockError.some))

        XCTAssertEqual(result, [localGoals, localGoals])
        XCTAssertEqual(mockGoalsService.calls, [.fetch])
        XCTAssertEqual(mockGoalsResponseMapper.calls, [.map(remoteGoalResponse),
                                                       .map(remoteGoalResponse)])
        XCTAssertEqual(
            mockStorage.calls, [
                .get("goals_key"),
                .get("goals_key")
            ]
        )
    }
}
