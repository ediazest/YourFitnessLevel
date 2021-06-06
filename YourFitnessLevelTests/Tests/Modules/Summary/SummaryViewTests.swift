//
//  SummaryViewTests.swift
//  YourFitnessLevelTests
//
//  Created by Eduardo Díaz Estrada on 06.06.21.
//

import SnapshotTesting
import XCTest
@testable import YourFitnessLevel

class SummaryViewTests: XCTestCase {

    override func setUp() {
        super.setUp()
        createTestDependencies(
            DateFormatterMock(),
            CalendarMock(),
            UserDefaultStorageMock()
        )
    }

    override func tearDown() {
        removeTestDependencies()
        super.tearDown()
    }

    func test_summaryView_whenNotRequestedBefore() {
        let view = SummaryView(state: SummaryViewStateMock())

        assertSnapshots(matching: view)
    }

    func test_summaryView_whenRequestedButEmptyResults() {
        let view = SummaryView(
            state: SummaryViewStateMock(
                contentType: .empty,
                requestedBefore: true
            )
        )
        assertSnapshots(matching: view)
    }

    func test_summaryView_whenActivityDataAvailable() {
        let view = SummaryView(
            state: SummaryViewStateMock(
                contentType: .data(
                    [
                        .init(
                            achievedDailyGoals: false,
                            currentProgress: 4000,
                            message: "Almost there",
                            nextGoal: 5000,
                            unit: "steps",
                            title: "Daily steps",
                            samples: []
                        ),
                        .init(
                            achievedDailyGoals: true,
                            currentProgress: 4000,
                            message: "Done",
                            nextGoal: 0,
                            unit: "km",
                            title: "Walking distance",
                            samples: []
                        ),
                        .init(
                            achievedDailyGoals: false,
                            currentProgress: 4000,
                            message: "Not yet",
                            nextGoal: 20000,
                            unit: "km",
                            title: "Running distance",
                            samples: []
                        )
                    ]
                ),
                requestedBefore: true
            )
        )
        assertSnapshots(matching: view)
    }
}

private class SummaryViewStateMock: SummaryViewState {
    init(
        date: String = "Sun, 6 Jun",
        contentType: SummaryViewData.ContentType = .empty,
        requestedBefore: Bool = false
    ) {
        super.init()
        viewData = .init(
            date: date,
            contentType: contentType,
            requestedBefore: requestedBefore
        )
    }
}
