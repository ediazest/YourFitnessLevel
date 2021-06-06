//
//  StatisticsQueryFactory.swift
//  YourFitnessLevel
//
//  Created by Eduardo Díaz Estrada on 06.06.21.
//

import HealthKit

typealias QueryResultHandler = ((HKStatisticsCollectionQuery, HKStatisticsCollection?, Error?) -> Void)

protocol StatisticsQueryFactoryProtocol {
    func collectionQuery(
        quantityType: HKQuantityType,
        quantitySamplePredicate: NSPredicate?,
        options: HKStatisticsOptions,
        anchorDate: Date,
        intervalComponents: DateComponents,
        initialResultsHandler: QueryResultHandler?
    ) -> HKStatisticsCollectionQuery
}

class StatisticsQueryFactory: StatisticsQueryFactoryProtocol {
    func collectionQuery(
        quantityType: HKQuantityType,
        quantitySamplePredicate: NSPredicate?,
        options: HKStatisticsOptions,
        anchorDate: Date,
        intervalComponents: DateComponents,
        initialResultsHandler: QueryResultHandler?
    ) -> HKStatisticsCollectionQuery {

        let query = HKStatisticsCollectionQuery(
            quantityType: quantityType,
            quantitySamplePredicate: quantitySamplePredicate,
            options: .cumulativeSum,
            anchorDate: anchorDate,
            intervalComponents: intervalComponents
        )
        query.initialResultsHandler = initialResultsHandler

        return query
    }
}
