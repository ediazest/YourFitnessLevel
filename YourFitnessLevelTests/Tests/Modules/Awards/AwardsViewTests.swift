//
//  AwardsViewTests.swift
//  YourFitnessLevelTests
//
//  Created by Eduardo Díaz Estrada on 06.06.21.
//

import SnapshotTesting
import XCTest
@testable import YourFitnessLevel

class AwardsViewTests: XCTestCase {
    private let mockActivityUseCase = ActivityUseCaseMock()
    private let mockGoalsUseCase = GoalsUseCaseMock()

    override func setUp() {
        super.setUp()
        createTestDependencies(
            mockActivityUseCase,
            mockGoalsUseCase
        )
    }

    override func tearDown() {
        removeTestDependencies()
        super.tearDown()
    }

    func test_awardsView() {
        let view = AwardsView(state: AwardsViewStateMock())

        assertSnapshots(matching: view)

    }

    func test_awardsView_whenNoData() {
        let view = AwardsView(state: AwardsViewStateMock(data: false))

        assertSnapshots(matching: view)

    }
}

private class AwardsViewStateMock: AwardsViewState {

    init(data: Bool = true) {
        super.init()

        if data {
            viewData = .init(
                points: 100,
                shouldDisplayHelpButton: true,
                awards: [
                    .init(
                        id: "id1",
                        image: "goldMedal",
                        title: "Run 5k",
                        detail: "foobar",
                        achieved: 0
                    ),
                    .init(
                        id: "id2",
                        image: "zombieHand",
                        title: "Run 15k",
                        detail: "foobar",
                        achieved: 15
                    ),
                    .init(
                        id: "id3",
                        image: "silverMedal",
                        title: "Run 2k",
                        detail: "foobar",
                        achieved: 1
                    ),
                    .init(
                        id: "id4",
                        image: "bronzeMedal",
                        title: "Run 1k",
                        detail: "foobar",
                        achieved: 5
                    )
                ]
            )

        } else {
            viewData = .init(
                points: 0,
                shouldDisplayHelpButton: false,
                awards: []
            )
        }
    }
}
