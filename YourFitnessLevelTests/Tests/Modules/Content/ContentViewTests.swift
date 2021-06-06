//
//  ContentViewTests.swift
//  YourFitnessLevelTests
//
//  Created by Eduardo Díaz Estrada on 06.06.21.
//

import SnapshotTesting
import XCTest
@testable import YourFitnessLevel

class ContentViewTests: XCTestCase {
    override func setUp() {
        super.setUp()
        createTestDependencies(
            DateFormatterMock(),
            CalendarMock(),
            UserDefaultStorageMock(),
            ActivityUseCaseMock(),
            GoalsUseCaseMock()
        )
    }

    override func tearDown() {
        removeTestDependencies()
        super.tearDown()
    }

    func test_contentView() {
        let view = ContentView(state: ContentViewStateMock())

        assertSnapshots(matching: view)
    }
}

private class ContentViewStateMock: ContentViewState {
    override func handleOnAppear() {}
}
