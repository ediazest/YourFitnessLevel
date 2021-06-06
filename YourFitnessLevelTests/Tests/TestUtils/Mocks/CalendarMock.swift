//
//  CalendarMock.swift
//  YourFitnessLevelTests
//
//  Created by Eduardo Díaz Estrada on 06.06.21.
//

import Foundation
@testable import YourFitnessLevel

class CalendarMock: CalendarProtocol {

    enum Call: Equatable {
        case date(DateComponents)
        case dateComponents(Set<Calendar.Component>, Date)
        case dateBy(Calendar.Component, Int, Date, Bool)
        case startOfDay(Date)
    }

    var calls: [Call] = []

    var currentDate: Date = Date()

    var returnedDate: Date?
    func date(from components: DateComponents) -> Date? {
        calls.append(.date(components))
        return returnedDate
    }

    var returnedDateComponents: DateComponents?
    func dateComponents(_ components: Set<Calendar.Component>, from date: Date) -> DateComponents {
        calls.append(.dateComponents(components, date))
        return returnedDateComponents!
    }

    var dateAdding: Date?
    func date(byAdding component: Calendar.Component, value: Int, to date: Date, wrappingComponents: Bool) -> Date? {
        calls.append(.dateBy(component, value, date, wrappingComponents))
        return dateAdding ?? returnedDate
    }

    var startOfDay: Date?
    func startOfDay(for date: Date) -> Date {
        calls.append(.startOfDay(date))
        return startOfDay ?? returnedDate!
    }
}
