//
//  Array.swift
//  YourFitnessLevel
//
//  Created by Eduardo Díaz Estrada on 04.06.21.
//

import Foundation

extension Array where Element == Value {
    var sum: Int {
        self.map { $0.count }
            .reduce(0, +)
    }
}

extension Array where Element == Activity {
    var steps: [Value] {
        self.filter { $0.isSteps }
            .flatMap { activity -> [Value] in
                if case let .steps(steps) = activity { return steps }
                return []
            }
    }

    var distance: [Value] {
        self.filter { $0.isRunning }
            .flatMap { activity -> [Value] in
                if case let .running(distance) = activity { return distance }
                return []
            }
    }
}

extension Array where Element == Goal {
    var steps: [Goal] {
        filter { $0.type == .step }
    }

    var distance: [Goal] {
        filter { $0.type == .running ||  $0.type == .walking }
    }
}
