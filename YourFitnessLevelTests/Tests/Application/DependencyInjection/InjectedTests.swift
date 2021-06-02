//
//  InjectedTests.swift
//  YourFitnessLevelTests
//
//  Created by Eduardo Díaz Estrada on 02.06.21.
//

import Foundation
@testable import YourFitnessLevel
import XCTest

class InjectedTests: XCTestCase {
    private let mockObject = SomeObject()
    private let mockContainer = DependencyContainerMock()

    override func setUp() {
        super.setUp()
        mockContainer.resolveReturnValue = mockObject
        DependencyContainerProvider.container = mockContainer
    }

    override func tearDown() {
        super.tearDown()
        DependencyContainerProvider.container = nil
    }

    func test_injected_lazy_is_true() {
        // given
        let wrapper = InstantlyInjectedWrapper()
        XCTAssertTrue(mockContainer.calls.isEmpty)

        // when
        _ = wrapper.object

        // then
        XCTAssertEqual(mockContainer.calls, [.resolve])
        XCTAssertTrue(wrapper.object === mockObject)

        // when
        _ = wrapper.object

        // then
        XCTAssertEqual(mockContainer.calls, [.resolve])
    }
}

private class InstantlyInjectedWrapper {
    @Injected var object: AnyObject
}

private class SomeObject {}
