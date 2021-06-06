//
//  HealthStoreMock.swift
//  YourFitnessLevelTests
//
//  Created by Eduardo Díaz Estrada on 06.06.21.
//

import HealthKit
@testable import YourFitnessLevel

class HealthStoreMock: HealthStoreProtocol {

    enum Call: Equatable {
        case requestAuthorization(Set<HKSampleType>?, Set<HKObjectType>?)
        case excute(HKQuery)
    }

    var calls: [Call] = []

    var isHealthDataAvailable: Bool = false

    var authorizationCompletionClosure: ((Bool, Error?) -> Void)?
    func requestAuthorization(
        toShare typesToShare: Set<HKSampleType>?,
        read typesToRead: Set<HKObjectType>?,
        completion: @escaping (Bool, Error?) -> Void
    ) {
        authorizationCompletionClosure = completion
        calls.append(.requestAuthorization(typesToShare, typesToRead))
    }

    func execute(_ query: HKQuery) {
        calls.append(.excute(query))
    }
}
