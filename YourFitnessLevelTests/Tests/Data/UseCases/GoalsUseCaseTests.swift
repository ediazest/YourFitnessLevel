//
//  GoalsUseCaseTests.swift
//  YourFitnessLevelTests
//
//  Created by Eduardo Díaz Estrada on 06.06.21.
//

import Combine
import CombineSchedulers
import XCTest
@testable import YourFitnessLevel

class GoalsUseCaseTests: XCTestCase {
    private let mockGoalsRepository = GoalsRepositoryMock()

    private var sut: GoalsUseCase!

    private var subscriptions: Set<AnyCancellable> = []

    override func setUp() {
        super.setUp()
        createTestDependencies(mockGoalsRepository)

        sut = .init(scheduler: .immediate)
    }

    override func tearDown() {
        removeTestDependencies()
        super.tearDown()
    }

    func test_forwardsGoals_fromRepository() {
        let repositoryGoals: [Goal] = [.fake(), .fake()]

        var result: [Goal]?

        sut.goals
            .sink(receiveValue: {
                result = $0
            })
            .store(in: &subscriptions)

        sut.fetchGoals()

        mockGoalsRepository.fetchSubject.send(repositoryGoals)

        XCTAssertEqual(result, repositoryGoals)
        XCTAssertEqual(mockGoalsRepository.calls, [.fetch])
    }

    func test_noGoals_whenRepositoryFails() {
        var result: [Goal]?

        sut.goals
            .sink(receiveValue: {
                result = $0
            })
            .store(in: &subscriptions)

        sut.fetchGoals()
        mockGoalsRepository.fetchSubject.send(completion: .failure(MockError.some))

        XCTAssertEqual(result, [])
        XCTAssertEqual(mockGoalsRepository.calls, [.fetch])
    }
}
