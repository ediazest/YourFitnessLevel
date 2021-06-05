//
//  CalendarProtocol.swift
//  YourFitnessLevel
//
//  Created by Eduardo Díaz Estrada on 05.06.21.
//

import Foundation

protocol CalendarProtocol {
    var currentDate: Date { get }

    func date(from components: DateComponents) -> Date?
    func dateComponents(_ components: Set<Calendar.Component>, from date: Date) -> DateComponents

    func date(byAdding component: Calendar.Component, value: Int, to date: Date, wrappingComponents: Bool) -> Date?

    func startOfDay(for date: Date) -> Date
}

extension Calendar: CalendarProtocol {
    var currentDate: Date {
        Date()
    }
}
