//
//  HKHealthStoreProtocol.swift
//  YourFitnessLevel
//
//  Created by Eduardo Díaz Estrada on 05.06.21.
//

import Foundation
import HealthKit

protocol HealthStoreProtocol {
    var isHealthDataAvailable: Bool { get }

    func requestAuthorization(
        toShare typesToShare: Set<HKSampleType>?,
        read typesToRead: Set<HKObjectType>?,
        completion: @escaping (Bool, Error?) -> Void
    )

    func execute(_ query: HKQuery)
}

extension HKHealthStore: HealthStoreProtocol {
    var isHealthDataAvailable: Bool {
        HKHealthStore.isHealthDataAvailable()
    }
}

enum ActivityTypeRequest {
    case steps, walking, running
}
