//
//  GoalsResponseMapperTests.swift
//  YourFitnessLevelTests
//
//  Created by Eduardo Díaz Estrada on 03.06.21.
//

import Foundation
import XCTest
@testable import YourFitnessLevel

class GoalsResponseMapperTests: XCTestCase {

    func test_mapsRespoonse_toGoals() {
        let sut = GoalsResponseMapper()

        let goalResponse = GoalResponse.fake(
            [
                .fake(type: "step", trophy: "bronze_medal"),
                .fake(trophy: "silver_medal"),
                .fake(type: "walking_distance", trophy: "gold_medal"),
                .fake(type: "running_distance", trophy: "zombie_hand"),
                .fake()
            ]
        )

        let goals = sut.map(goalResponse)

        XCTAssertEqual(goals.count, goalResponse.items.count)

        for (index, item) in goals.enumerated() {
            XCTAssertEqual(item.identifier, goalResponse.items[index].identifier)
            XCTAssertEqual(item.title, goalResponse.items[index].title)
            XCTAssertEqual(item.description, goalResponse.items[index].description)
            XCTAssertEqual(item.type, GoalType(rawValue: goalResponse.items[index].type))
            XCTAssertEqual(item.goal, goalResponse.items[index].goal)
            XCTAssertEqual(item.reward, .init(
                            trophy: Trophy(rawValue: goalResponse.items[index].reward.trophy) ?? Trophy.bronze,
                            points: goalResponse.items[index].reward.points))
        }
    }
}
