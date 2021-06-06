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

        sut = .init()
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
}
