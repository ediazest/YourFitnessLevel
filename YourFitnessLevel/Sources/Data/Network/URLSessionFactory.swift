//
//  URLSessionFactory.swift
//  YourFitnessLevel
//
//  Created by Eduardo Díaz Estrada on 03.06.21.
//

import Combine
import Foundation

protocol URLSessionProtocol {
    func dataTask(for request: URLRequest) -> AnyPublisher<(data: Data, response: URLResponse), URLError>
}

extension URLSession: URLSessionProtocol {
    func dataTask(for request: URLRequest) -> AnyPublisher<(data: Data, response: URLResponse), URLError> {
        dataTaskPublisher(for: request).eraseToAnyPublisher()
    }
}

protocol URLSessionFactoryProtocol {
    func createURLSession() -> URLSessionProtocol
}

class URLSessionFactory: URLSessionFactoryProtocol {
    func createURLSession() -> URLSessionProtocol {
        URLSession.shared
    }
}
