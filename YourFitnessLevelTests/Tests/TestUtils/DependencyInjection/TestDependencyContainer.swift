//
//  TestDependencyContainer.swift
//  YourFitnessLevelTests
//
//  Created by Eduardo Díaz Estrada on 02.06.21.
//

import Foundation
@testable import YourFitnessLevel

final class TestDependencyContainer: DependencyContainer {
    private var dependencies: [Any] = []

    init(dependencies: [Any] = []) {
        self.dependencies = dependencies
    }

    func register<T>(with policy: DependencyRetainPolicy, builder: @escaping (DependencyContainer) throws -> T) {}

    func resolve<T>() throws -> T! {
        dependencies.first(where: { $0 is T }) as? T
    }
}

private func createTestDependencies(_ dependencies: [Any]) {
    DependencyContainerProvider.container = TestDependencyContainer(dependencies: dependencies)
}

public func removeTestDependencies() {
    DependencyContainerProvider.container = nil
}
