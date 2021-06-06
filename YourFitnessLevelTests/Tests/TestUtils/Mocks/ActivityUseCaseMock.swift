//
//  ActivityUseCaseMock.swift
//  YourFitnessLevelTests
//
//  Created by Eduardo Díaz Estrada on 06.06.21.
//

import Combine
@testable import YourFitnessLevel

class ActivityUseCaseMock: ActivityUseCaseProtocol {

    enum Call: Equatable {
        case fetch
    }

    var calls: [Call] = []

    let activitiesSubject = PassthroughSubject<[Activity], Never>()
    lazy var todaysActivities: AnyPublisher<[Activity], Never> = activitiesSubject.testable

    let runningMonthStepsSubject = PassthroughSubject<[Activity], Never>()
    lazy var runningMonthActivities: AnyPublisher<[Activity], Never> = runningMonthStepsSubject.testable

    func fetch() {
        calls.append(.fetch)
    }
}
