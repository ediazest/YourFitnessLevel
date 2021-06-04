//
//  DeferredFuture.swift
//  YourFitnessLevel
//
//  Created by Eduardo Díaz Estrada on 04.06.21.
//

import Combine

public struct DeferredFuture<Output, Failure>: Publisher where Failure: Error {
    public typealias Promise = (Result<Output, Failure>) -> Void
    private let publisher: Deferred<Future<Output, Failure>>

    public init(_ attemptToFulfill: @escaping (@escaping Promise) -> Void) {
        publisher = Deferred { Future(attemptToFulfill) }
    }

    public func receive<S>(subscriber: S) where S: Subscriber, Failure == S.Failure, Output == S.Input {
        publisher.receive(subscriber: subscriber)
    }
}
