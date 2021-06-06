//
//  DateFormatterMock.swift
//  YourFitnessLevelTests
//
//  Created by Eduardo Díaz Estrada on 06.06.21.
//

import Foundation
@testable import YourFitnessLevel

class DateFormatterMock: DateFormatterProtocol {
    enum Call: Equatable {
        case string(Date)
    }

    var calls: [Call] = []

    var dateFormat: String! = ""

    var returnedString: String = ""
    func string(from date: Date) -> String {
        calls.append(.string(date))
        return returnedString
    }
}
