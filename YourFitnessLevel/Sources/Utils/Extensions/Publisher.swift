//
//  Publishers.swift
//  YourFitnessLevel
//
//  Created by Eduardo Díaz Estrada on 06.06.21.
//

import Combine

extension Publisher {
    var asVoidPublisher: AnyPublisher<Void, Failure> {
        map { _ in }.eraseToAnyPublisher()
    }

    func subscribe() -> AnyCancellable {
        asVoidPublisher
            .sink(receiveCompletion: { _ in }, receiveValue: { _ in })
    }
}
