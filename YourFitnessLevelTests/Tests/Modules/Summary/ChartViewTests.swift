//
//  ChartViewTests.swift
//  YourFitnessLevelTests
//
//  Created by Eduardo Díaz Estrada on 06.06.21.
//

import SnapshotTesting
import XCTest
@testable import YourFitnessLevel

class ChartViewTests: XCTestCase {

    override func setUp() {
        super.setUp()
        createTestDependencies(
            CalendarMock()
        )
    }

    override func tearDown() {
        removeTestDependencies()
        super.tearDown()
    }

    func test_emptyChart() {
        let view = ChartView(
            state: ChartViewStateMock()
        )

        assertSnapshots(matching: view)
    }

    func test_validChart() {
        let view = ChartView(
            state: ChartViewStateMock(
                chartViewData: .data(
                    axis: ["00:00", "06:00", "12:00", "18:00"],
                    maxValue: 300,
                    samples: [
                        .init(value: 100),
                        .init(value: 300),
                        .init(value: 150),
                        .init(value: 90),
                        .init(value: 110),
                        .init(value: 0),
                        .init(value: 0),
                        .init(value: 0),
                        .init(value: 0),
                        .init(value: 0),
                        .init(value: 279),
                        .init(value: 259),
                        .init(value: 280)
                    ]
                )
            )
        )

        assertSnapshots(matching: view)
    }
}

private class ChartViewStateMock: ChartViewState {
    init(
        chartViewData: ChartViewData = .empty(axis: ["00:00", "06:00"])
    ) {
        super.init(samples: [])
        viewData = chartViewData
    }
}
