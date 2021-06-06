//
//  StatisticsQueryFactoryMock.swift
//  YourFitnessLevelTests
//
//  Created by Eduardo Díaz Estrada on 06.06.21.
//

import HealthKit
@testable import YourFitnessLevel

class StatisticsQueryFactoryMock: StatisticsQueryFactoryProtocol {

    enum Call: Equatable {
        case collection(
                quantityType: HKQuantityType,
                quantitySamplePredicate: NSPredicate?,
                options: HKStatisticsOptions,
                anchorDate: Date,
                intervalComponents: DateComponents
             )
    }

    var calls: [Call] = []

    var queryHandler: QueryResultHandler?

    var returnedQuery: HKStatisticsCollectionQuery?
    func collectionQuery(
        quantityType: HKQuantityType,
        quantitySamplePredicate: NSPredicate?,
        options: HKStatisticsOptions,
        anchorDate: Date,
        intervalComponents: DateComponents,
        initialResultsHandler: QueryResultHandler?
    ) -> HKStatisticsCollectionQuery {
        queryHandler = initialResultsHandler

        calls.append(
            .collection(
                quantityType: quantityType,
                quantitySamplePredicate: quantitySamplePredicate,
                options: options,
                anchorDate: anchorDate,
                intervalComponents: intervalComponents
            )
        )
        return returnedQuery!
    }
}
