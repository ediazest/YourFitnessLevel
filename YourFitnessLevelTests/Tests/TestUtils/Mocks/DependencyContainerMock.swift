//
//  DependencyContainerMock.swift
//  YourFitnessLevelTests
//
//  Created by Eduardo Díaz Estrada on 02.06.21.
//

import Foundation
@testable import YourFitnessLevel

class DependencyContainerMock: DependencyContainer {
    enum Call: Equatable {
        case register(policy: DependencyRetainPolicy)
        case resolve
        case resolveAll
    }

    var calls: [Call] = []

    func register<T>(with policy: DependencyRetainPolicy, builder _: @escaping (DependencyContainer) throws -> T) {
        calls.append(.register(policy: policy))
    }

    var resolveReturnValue: AnyObject?
    var resolveReturnValues: [String: AnyObject] = [:]
    func resolve<T>() throws -> T! {
        calls.append(.resolve)

        let key = String(reflecting: T.self)
        if resolveReturnValues[key] != nil {
            return resolveReturnValues[key] as? T
        }

        return resolveReturnValue as? T
    }
}
