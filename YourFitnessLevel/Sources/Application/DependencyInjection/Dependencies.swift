//
//  Dependencie.swift
//  YourFitnessLevel
//
//  Created by Eduardo Díaz Estrada on 02.06.21.
//

import Foundation

func injectDependencies(into container: DependencyContainer) {
    container.register(with: .factory) { _ -> JSONDecoderProtocol in
        JSONDecoder()
    }

    container.register(with: .factory) { _ -> JSONEncoderProtocol in
        JSONEncoder()
    }

    container.register(with: .factory) { _ -> UserDefaultStorageProtocol in
        UserDefaultStorage()
    }

    container.register(with: .factory) { _ -> UserDefaultsProtocol in
        UserDefaults.standard
    }

    container.register(with: .factory) { _ -> HttpClientProtocol in
        HttpClient()
    }

    container.register(with: .factory) { _ -> URLSessionFactoryProtocol in
        URLSessionFactory()
    }

    container.register(with: .singleton) { _ -> GoalsServiceProtocol in
        GoalsService()
    }

    container.register(with: .singleton) { _ -> GoalsRepositoryProtocol in
        GoalsRepository()
    }

    container.register(with: .singleton) { _ -> GoalsResponseMapperProtocol in
        GoalsResponseMapper()
    }

    container.register(with: .singleton) { _ -> AwardsUseCaseProtocol in
        AwardsUseCase()
    }

    container.register(with: .singleton) { _ -> GoalsUseCaseProtocol in
        GoalsUseCase()
    }
}
