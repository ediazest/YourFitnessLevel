//
//  Injected.swift
//  YourFitnessLevel
//
//  Created by Eduardo Díaz Estrada on 02.06.21.
//

import Foundation

@propertyWrapper
class Injected<T> {
    private var container: DependencyContainer {
        DependencyContainerProvider.container
    }

    lazy var wrappedValue: T = {
        do {
            return try container.resolve()
        } catch {
            fatalError(error.localizedDescription)
        }
    }()
}
