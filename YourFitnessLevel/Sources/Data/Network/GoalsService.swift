//
//  GoalsService.swift
//  YourFitnessLevel
//
//  Created by Eduardo Díaz Estrada on 03.06.21.
//

import Combine
import Foundation

protocol GoalsServiceProtocol {
    func fetch() -> AnyPublisher<GoalResponse, Error>
}

class GoalsService: GoalsServiceProtocol {
    @Injected private var httpClient: HttpClientProtocol

    private var goalsUrl: URL? {
        URL(string: "https://thebigachallenge.appspot.com/_ah/api/myApi/v1/goals")
    }

    func fetch() -> AnyPublisher<GoalResponse, Error> {
        guard let url = goalsUrl else {
            return Fail(error: ServiceError.invalidUrl).eraseToAnyPublisher()
        }

        return httpClient.request(.init(url: url))
    }
}

private enum ServiceError: Error {
    case invalidUrl
}
