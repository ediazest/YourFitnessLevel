//
//  AppContainerTests.swift
//  YourFitnessLevelTests
//
//  Created by Eduardo Díaz Estrada on 02.06.21.
//

import Foundation
import XCTest
@testable import YourFitnessLevel

class AppContainerTests: XCTestCase {

    private let sut = AppContainer()

    func test_resolve_unregistered() {
        // given
        var error: Error?
        var object: SomeProtocol?

        // when
        do {
            object = try sut.resolve()
        } catch let containerError {
            error = containerError
        }

        // then
        XCTAssertNil(object)
        XCTAssertEqual(
            error?.localizedDescription,
            DependencyContainerError.missingFactoryMethod(SomeProtocol.self).localizedDescription
        )
    }

    func test_register_twice() {
        // given
        let policies: [DependencyRetainPolicy] = [.factory, .singleton]
        let object1 = Object()
        let object2 = Object()

        // when
        policies.forEach { policy in
            sut.register(with: policy) { _ -> SomeProtocol in object1 }
            _ = try? (sut.resolve() as SomeProtocol)
            sut.register(with: policy) { _ -> SomeProtocol in object2 }

            // then
            XCTAssertTrue(try! sut.resolve() as SomeProtocol === object2)
        }
    }

    func test_register_factory_policy_resolve() {
        // given
        var error: Error?
        var object: SomeProtocol?
        var initCalls = 0

        sut.register(with: .factory) { _ -> SomeProtocol in
            Object(block: { initCalls += 1 })
        }

        // when
        do {
            object = try sut.resolve()
        } catch let containerError {
            error = containerError
        }

        // then
        XCTAssertNil(error)
        XCTAssertNotNil(object)
        XCTAssertEqual(1, initCalls)

        // when
        do {
            object = try sut.resolve()
        } catch let containerError {
            error = containerError
        }

        // then
        XCTAssertNil(error)
        XCTAssertNotNil(object)
        XCTAssertEqual(2, initCalls)
    }

    func test_register_singleton_policy_resolve() {
        // given
        var error: Error?
        var object: SomeProtocol?
        var initCalls = 0

        sut.register(with: .singleton) { _ -> SomeProtocol in
            Object(block: { initCalls += 1 })
        }

        // when
        do {
            object = try sut.resolve()
        } catch let containerError {
            error = containerError
        }

        // then
        XCTAssertNil(error)
        XCTAssertNotNil(object)
        XCTAssertEqual(1, initCalls)

        // when
        do {
            object = try sut.resolve()
        } catch let containerError {
            error = containerError
        }

        // then
        XCTAssertNil(error)
        XCTAssertNotNil(object)
        XCTAssertEqual(1, initCalls)
    }
}

// MARK: - Private
private protocol SomeProtocol: AnyObject {}
private class Object: SomeProtocol {
    init(block: (() -> Void)? = nil) { block?() }
}
