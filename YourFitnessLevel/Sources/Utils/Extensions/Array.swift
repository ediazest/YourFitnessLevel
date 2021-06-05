//
//  Array.swift
//  YourFitnessLevel
//
//  Created by Eduardo Díaz Estrada on 04.06.21.
//

import Foundation

extension Array where Element == Step {
    var sum: Int {
        self.map { $0.count }
            .reduce(0, +)
    }
}
