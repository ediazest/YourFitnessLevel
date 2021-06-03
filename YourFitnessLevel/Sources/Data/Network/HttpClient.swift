//
//  HttpClient.swift
//  YourFitnessLevel
//
//  Created by Eduardo Díaz Estrada on 03.06.21.
//

import Combine
import Foundation

protocol HttpClientProtocol {
    func request<T: Decodable>(_ request: URLRequest) -> AnyPublisher<T, Error>
}

class HttpClient: HttpClientProtocol {
    @Injected private var decoder: JSONDecoderProtocol
    @Injected private var sessionFactory: URLSessionFactoryProtocol

    private lazy var session: URLSessionProtocol = sessionFactory.createURLSession()

    func request<T: Decodable>(_ request: URLRequest) -> AnyPublisher<T, Error> {
        session.dataTask(for: request)
            .tryMap { [decoder] data, _ in
                return try decoder.decode(from: data)
        }
        .eraseToAnyPublisher()
    }
}
