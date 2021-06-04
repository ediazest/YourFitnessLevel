//
//  UserDefaultStorageMock.swift
//  YourFitnessLevelTests
//
//  Created by Eduardo Díaz Estrada on 03.06.21.
//

import Foundation
@testable import YourFitnessLevel

class UserDefaultStorageMock: UserDefaultStorageProtocol {
    enum Call: Equatable {
        case get(String)
        case set(String)
    }

    var calls: [Call] = []

    var returnedValue: Any?
    func get<T>(key: String) throws -> T? {
        calls.append(.get(key))
        return returnedValue as? T
    }

    func set<T: Encodable>(value: T, key: String) throws {
        calls.append(.set(key))
    }
}
