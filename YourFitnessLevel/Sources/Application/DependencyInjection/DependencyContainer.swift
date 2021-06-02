//
//  DependencyContainer.swift
//  YourFitnessLevel
//
//  Created by Eduardo Díaz Estrada on 02.06.21.
//

import Foundation

enum DependencyRetainPolicy {
    case factory
    case singleton
}

enum DependencyContainerError: LocalizedError {
    case missingFactoryMethod(Any)

    public var errorDescription: String? {
        switch self {
        case let .missingFactoryMethod(intanceType):
            return "Missing factory method for instance: \(intanceType)"
        }
    }
}

struct DependencyContainerProvider {
    // swiftlint:disable implicitly_unwrapped_optional
    static var container: DependencyContainer!
}

protocol DependencyContainer {
    func register<T>(with policy: DependencyRetainPolicy, builder: @escaping (DependencyContainer) throws -> T)
    func resolve<T>() throws -> T!
}

class AppContainer: DependencyContainer {
    private struct Factory {
        let policy: DependencyRetainPolicy
        let build: (DependencyContainer) throws -> Any
    }

    private var factories: [String: Factory] = [:]
    private var instances: [String: Any] = [:]

    private let lock = NSRecursiveLock()

    func register<T>(with policy: DependencyRetainPolicy, builder: @escaping (DependencyContainer) throws -> T) {
        let key = String(reflecting: T.self)

        instances[key] = nil

        factories[key] = Factory(policy: policy, build: builder)
    }

    func resolve<T>() throws -> T! {
        lock.lock(); defer { lock.unlock() }

        let key = String(reflecting: T.self)
        guard let factory = factories[key] else {
            throw DependencyContainerError.missingFactoryMethod(T.self)
        }

        switch factory.policy {
        case .factory:
            return try factory.build(self) as? T
        case .singleton:
            if let instance = instances[key] as? T {
                return instance
            }

            let instance = try factory.build(self) as? T
            instances[key] = instance

            return instance
        }
    }
}
