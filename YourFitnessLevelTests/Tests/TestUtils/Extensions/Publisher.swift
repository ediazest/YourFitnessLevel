//
//  Publishers.swift
//  YourFitnessLevelTests
//
//  Created by Eduardo Díaz Estrada on 06.06.21.
//

import Combine
import CombineSchedulers
import Foundation

extension Publisher {
    var testable: AnyPublisher<Output, Failure> {
        subscribe(on: DispatchQueue.immediate)
            .receive(on: DispatchQueue.immediate)
            .eraseToAnyPublisher()
    }
}
