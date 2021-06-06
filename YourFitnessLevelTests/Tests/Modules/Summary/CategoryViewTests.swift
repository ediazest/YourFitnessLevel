//
//  CategoryViewTests.swift
//  YourFitnessLevelTests
//
//  Created by Eduardo Díaz Estrada on 06.06.21.
//

import SnapshotTesting
import XCTest
@testable import YourFitnessLevel

class CategoryViewTests: XCTestCase {
    private let mockCalendar = CalendarMock()

    override func setUp() {
        super.setUp()
        createTestDependencies(
            mockCalendar
        )
        mockCalendar.currentDate = Date()
    }

    override func tearDown() {
        removeTestDependencies()
        super.tearDown()
    }

    func test_categoryView_expanded_displaysChart() {
        let view = CategoryView(
            category: .init(
                achievedDailyGoals: false,
                currentProgress: 4000,
                message: "Almost there",
                nextGoal: 5000,
                unit: "steps",
                title: "Daily steps",
                samples: [
                    .init(date: mockCalendar.currentDate, value: 150),
                    .init(date: mockCalendar.currentDate, value: 250)
                ]
            ),
            displayChart: true
        )

        assertSnapshots(matching: view)
    }

    func test_categoryView_expanded_noData() {
        let view = CategoryView(
            category: .init(
                achievedDailyGoals: false,
                currentProgress: 4000,
                message: "Almost there",
                nextGoal: 5000,
                unit: "steps",
                title: "Daily steps",
                samples: []
            ),
            displayChart: true
        )

        assertSnapshots(matching: view)
    }

    func test_categoryView_expanded_collapsed() {
        let view = CategoryView(
            category: .init(
                achievedDailyGoals: false,
                currentProgress: 4000,
                message: "Almost there",
                nextGoal: 5000,
                unit: "steps",
                title: "Daily steps",
                samples: []
            )
        )

        assertSnapshots(matching: view)
    }
}
