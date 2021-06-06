//
//  Dependencie.swift
//  YourFitnessLevel
//
//  Created by Eduardo Díaz Estrada on 02.06.21.
//

import Foundation
import HealthKit

func injectDependencies(into container: DependencyContainer) {
    injectUtilities(into: container)
    injectServices(into: container)
    injectRepositories(into: container)
    injectUseCases(into: container)
}

// MARK: - Services & DataSources
private func injectServices(into container: DependencyContainer) {
    container.register(with: .factory) { _ -> HealthStoreProtocol in
        HKHealthStore()
    }

    container.register(with: .singleton) { _ -> GoalsServiceProtocol in
        GoalsService()
    }

    container.register(with: .factory) { _ -> HttpClientProtocol in
        HttpClient()
    }

    container.register(with: .factory) { _ -> URLSessionFactoryProtocol in
        URLSessionFactory()
    }

    container.register(with: .factory) { _ -> UserDefaultStorageProtocol in
        UserDefaultStorage()
    }
}

// MARK: - UseCase
private func injectUseCases(into container: DependencyContainer) {
    container.register(with: .singleton) { _ -> GoalsUseCaseProtocol in
        GoalsUseCase()
    }

    container.register(with: .singleton) { _ -> ActivityUseCaseProtocol in
        ActivityUseCase()
    }
}

// MARK: - Repositories
private func injectRepositories(into container: DependencyContainer) {
    container.register(with: .singleton) { _ -> GoalsRepositoryProtocol in
        GoalsRepository()
    }

    container.register(with: .singleton) { _ -> GoalsResponseMapperProtocol in
        GoalsResponseMapper()
    }

    container.register(with: .singleton) { _ -> HealthDataRepositoryProtocol in
        HealthDataRepository()
    }
}

// MARK: - Favorites & Utils
private func injectUtilities(into container: DependencyContainer) {

    container.register(with: .factory) { _ -> StatisticsQueryFactoryProtocol in
        StatisticsQueryFactory()
    }

    container.register(with: .factory) { _ -> JSONDecoderProtocol in
        JSONDecoder()
    }

    container.register(with: .factory) { _ -> JSONEncoderProtocol in
        JSONEncoder()
    }

    container.register(with: .factory) { _ -> CalendarProtocol in
        Calendar.current
    }

    container.register(with: .factory) { _ -> DateFormatterProtocol in
        DateFormatter()
    }

    container.register(with: .factory) { _ -> UserDefaultsProtocol in
        UserDefaults.standard
    }
}
