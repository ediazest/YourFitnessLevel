//
//  UserDefaultsProtocol.swift
//  YourFitnessLevel
//
//  Created by Eduardo Díaz Estrada on 03.06.21.
//

import Foundation

protocol UserDefaultsProtocol {
    func object(forKey defaultName: String) -> Any?
    func set(_ value: Any?, forKey key: String)
    func data(forKey key: String) -> Data?
}

extension UserDefaults: UserDefaultsProtocol {}
