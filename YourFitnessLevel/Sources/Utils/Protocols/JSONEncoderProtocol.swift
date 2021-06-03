//
//  JSONEncoderProtocol.swift
//  YourFitnessLevel
//
//  Created by Eduardo Díaz Estrada on 03.06.21.
//

import Foundation

protocol JSONEncoderProtocol {
    func encode<T: Encodable>(_ value: T) throws -> Data
}

extension JSONEncoder: JSONEncoderProtocol {}
