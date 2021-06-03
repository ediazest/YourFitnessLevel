//
//  Subscribers.swift
//  YourFitnessLevelTests
//
//  Created by Eduardo Díaz Estrada on 03.06.21.
//

import Combine

extension Subscribers.Completion {
    var error: Failure? {
        guard case let .failure(error) = self else { return nil }
        return error
    }

    var isFinished: Bool {
        guard case .finished = self else { return false }
        return true
    }
}
