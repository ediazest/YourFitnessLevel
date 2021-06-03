//
//  GoalsServiceTests.swift
//  YourFitnessLevelTests
//
//  Created by Eduardo Díaz Estrada on 03.06.21.
//

import Combine
import Foundation
import XCTest
@testable import YourFitnessLevel

class GoalsServiceTests: XCTestCase {
    private var mockHttpClient = HttpClientMock()

    private var subscriptions: Set<AnyCancellable> = []
    private var sut: GoalsService!

    override func setUp() {
        super.setUp()
        createTestDependencies(mockHttpClient)
        sut = .init()
    }

    override func tearDown() {
        removeTestDependencies()
        super.tearDown()
    }

    func test_request_goals_publishes_result() {

        let expectedResponse: GoalResponse = .fake([.fake()])
        var result: GoalResponse?

        sut.fetch()
            .sink(receiveCompletion: {
                guard case .finished = $0 else {
                    XCTFail("Should not fail")
                    return
                }
            }, receiveValue: { result = $0 })
            .store(in: &subscriptions)

        mockHttpClient.requestSubject.send(expectedResponse)

        XCTAssertEqual(mockHttpClient.calls, [.request("https://thebigachallenge.appspot.com/_ah/api/myApi/v1/goals")])
        XCTAssertEqual(result, expectedResponse)
    }

    func test_request_goals_publishes_error() {
        var completion: Subscribers.Completion<Error>?

        sut.fetch()
            .sink(receiveCompletion: {
                completion = $0
            }, receiveValue: { _ in XCTFail("Should not receive value") }
            ).store(in: &subscriptions)

        mockHttpClient.requestSubject.send(completion: .failure(MockError.some))

        XCTAssertEqual(mockHttpClient.calls, [.request("https://thebigachallenge.appspot.com/_ah/api/myApi/v1/goals")])
        XCTAssertEqual(completion?.error?.localizedDescription, MockError.some.localizedDescription)
    }
}
