//
//  ContentViewStateTests.swift
//  YourFitnessLevelTests
//
//  Created by Eduardo Díaz Estrada on 06.06.21.
//

import XCTest
@testable import YourFitnessLevel

class ContentViewStateTests: XCTestCase {
    private let mockGoalsUseCase = GoalsUseCaseMock()

    private var sut: ContentViewState!

    override func setUp() {
        super.setUp()
        createTestDependencies(
            mockGoalsUseCase
        )

        sut = .init()
    }

    override func tearDown() {
        removeTestDependencies()
        super.tearDown()
    }

    func test_fetchesGoals_onViewAppear() {
        XCTAssertTrue(mockGoalsUseCase.calls.isEmpty)
        sut.handleOnAppear()
        XCTAssertEqual(mockGoalsUseCase.calls, [.fetch])
    }
}
