//
//  JSONDecoderProtocol.swift
//  YourFitnessLevel
//
//  Created by Eduardo Díaz Estrada on 03.06.21.
//

import Foundation

protocol JSONDecoderProtocol {
    func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T
}

extension JSONDecoderProtocol {
    func decode<T: Decodable>(from data: Data) throws -> T {
        try decode(T.self, from: data)
    }
}

extension JSONDecoder: JSONDecoderProtocol {}
