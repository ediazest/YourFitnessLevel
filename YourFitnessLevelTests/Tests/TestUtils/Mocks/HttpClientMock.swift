//
//  HttpClientMock.swift
//  YourFitnessLevelTests
//
//  Created by Eduardo Díaz Estrada on 03.06.21.
//

import Combine
import Foundation
@testable import YourFitnessLevel

class HttpClientMock: HttpClientProtocol {
    enum Call: Equatable {
        case request(String)
    }

    var calls: [Call] = []

    let requestSubject: PassthroughSubject<Any, Error> = .init()
    func request<T>(_ request: URLRequest) -> AnyPublisher<T, Error> where T: Decodable {
        calls.append(.request(request.url?.absoluteString ?? ""))
        return requestSubject.map { $0 as! T }.eraseToAnyPublisher()
    }
}
