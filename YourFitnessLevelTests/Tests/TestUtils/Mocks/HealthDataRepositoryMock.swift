//
//  HealthDataRepositoryMock.swift
//  YourFitnessLevelTests
//
//  Created by Eduardo Díaz Estrada on 06.06.21.
//

import Combine
import Foundation
@testable import YourFitnessLevel

class HealthDataRepositoryMock: HealthDataRepositoryProtocol {
    enum Call: Equatable {
        case fetch(Date, Date, Int, ActivityTypeRequest)
    }

    var calls: [Call] = []

    var isAvailable: Bool = false

    var activitySubject = PassthroughSubject<Activity, Error>()
    func fetchActivityData(startDate: Date, endDate: Date, intervalInMinutes: Int, type: ActivityTypeRequest) -> AnyPublisher<Activity, Error> {
        calls.append(.fetch(startDate, endDate, intervalInMinutes, type))
        return activitySubject.testable
    }
}
