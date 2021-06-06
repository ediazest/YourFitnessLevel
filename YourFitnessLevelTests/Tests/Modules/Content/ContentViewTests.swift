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
    func test_contentView() {
        let view = ContentView()

        assertSnapshots(matching: view)
    }
}
