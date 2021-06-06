//
//  HelpViewTests.swift
//  YourFitnessLevelTests
//
//  Created by Eduardo Díaz Estrada on 06.06.21.
//

import SnapshotTesting
import XCTest
@testable import YourFitnessLevel

class HelpViewTests: XCTestCase {
    func test_helpView() {
        let view = HelpView(state: HelpViewStateMock())

        assertSnapshots(matching: view)

    }
}

private class HelpViewStateMock: HelpViewState {
    init() {
        super.init()
        viewData = .init(goals: [
            .init(id: "id1",
                  title: "Gold medal",
                  description: "Run for 5km",
                  points: 45,
                  image: "goldMedal"
            ),
            .init(id: "id2",
                  title: "Silver medal",
                  description: "Run for 3km",
                  points: 20,
                  image: "silverMedal"
            ),
            .init(id: "id3",
                  title: "Bronze medal",
                  description: "Run for 1km",
                  points: 10,
                  image: "bronzeMedal"
            )
        ])
    }
}
