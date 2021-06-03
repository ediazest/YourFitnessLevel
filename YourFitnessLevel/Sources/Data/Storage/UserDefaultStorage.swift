//
//  UserDefaultStorage.swift
//  YourFitnessLevel
//
//  Created by Eduardo Díaz Estrada on 03.06.21.
//

import Foundation

protocol UserDefaultStorageProtocol {
    func get<T: Decodable>(key: String) throws -> T?
    func set<T: Encodable>(value: T, key: String) throws
}

class UserDefaultStorage: UserDefaultStorageProtocol {
    @Injected private var decoder: JSONDecoderProtocol
    @Injected private var encoder: JSONEncoderProtocol
    @Injected private var userDefaults: UserDefaultsProtocol

    func get<T: Decodable>(key: String) throws -> T? {
        if let object = userDefaults.object(forKey: key) as? T {
            return object
        }

        guard let data = userDefaults.data(forKey: key) else {
            return nil
        }

        if let object = data as? T {
            return object
        }

        return try decoder.decode(from: data)
    }

    func set<T: Encodable>(value: T, key: String) throws {
        if let string = value as? String {
            userDefaults.set(string, forKey: key)
            return
        }

        let data = try encoder.encode(value)
        userDefaults.set(data, forKey: key)
    }
}
