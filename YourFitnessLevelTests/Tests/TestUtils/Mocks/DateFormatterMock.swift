//
//  DateFormatterMock.swift
//  YourFitnessLevelTests
//
//  Created by Eduardo Díaz Estrada on 06.06.21.
//

import Foundation
@testable import YourFitnessLevel

class DateFormatterMock: DateFormatterProtocol {
    var dateFormat: String! = ""

    func string(from date: Date) -> String {
        date.description
    }
}
