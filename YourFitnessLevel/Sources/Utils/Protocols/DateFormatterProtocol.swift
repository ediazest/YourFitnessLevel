//
//  DateFormatterProtocol.swift
//  YourFitnessLevel
//
//  Created by Eduardo Díaz Estrada on 05.06.21.
//

import Foundation

protocol DateFormatterProtocol {
    var dateFormat: String! { get set }
    func string(from date: Date) -> String
}

extension DateFormatter: DateFormatterProtocol {}
