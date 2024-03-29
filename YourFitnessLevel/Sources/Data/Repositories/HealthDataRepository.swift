//
//  HealthDataRepository.swift
//  YourFitnessLevel
//
//  Created by Eduardo Díaz Estrada on 05.06.21.
//

import Combine
import Foundation
import HealthKit

protocol HealthDataRepositoryProtocol {
    var isAvailable: Bool { get }

    func fetchActivityData(
        startDate: Date,
        endDate: Date,
        intervalInMinutes: Int,
        type: ActivityTypeRequest
    ) -> AnyPublisher<Activity, Error>
}

class HealthDataRepository: HealthDataRepositoryProtocol {
    @Injected private var calendar: CalendarProtocol
    @Injected private var healthStore: HealthStoreProtocol
    @Injected private var storage: UserDefaultStorageProtocol
    @Injected private var statisticsQueryFactory: StatisticsQueryFactoryProtocol

    var isAvailable: Bool {
        healthStore.isHealthDataAvailable
    }

    func fetchActivityData(
        startDate: Date,
        endDate: Date,
        intervalInMinutes: Int,
        type: ActivityTypeRequest
    ) -> AnyPublisher<Activity, Error> {
        requestHealthKitPermission()
            .flatMap { [readUserActivity] result -> AnyPublisher<Activity, Error> in
                guard result, type != .walking else {
                    return Fail(error: HealthStoreError.permissionNotGranted).eraseToAnyPublisher()
                }
                return readUserActivity(
                    type,
                    startDate,
                    endDate,
                    intervalInMinutes)
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }

    private func requestHealthKitPermission() -> AnyPublisher<Bool, Error> {
        DeferredFuture<Bool, Error> { [healthStore, storage] promise in
            guard let stepCountRequest = HKObjectType.quantityType(forIdentifier: .stepCount),
                  let walkingRunningDistanceRequest = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)
                  else {
                promise(.failure(HealthStoreError.noStepCount))
                return
            }
            let workoutsRequest = HKObjectType.workoutType()

            healthStore.requestAuthorization(
                toShare: [],
                read: [stepCountRequest, workoutsRequest, walkingRunningDistanceRequest]) { success, error in
                guard let error = error else {
                    promise(.success(success))
                    try? storage.set(value: true, key: .healthAccessRequested)
                    return
                }
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }

    private func readUserActivity(type: ActivityTypeRequest, startDate: Date, endDate: Date, intervalInMinutes: Int) -> AnyPublisher<Activity, Error> {
        DeferredFuture<Activity, Error> { [healthStore, anchorDate, statisticsQueryFactory] promise in
            guard let anchorDate = anchorDate else {
                promise(.failure(HealthStoreError.invalidDateTimeframe))
                return
            }

            let quantityTypeIdentifier: HKQuantityTypeIdentifier = type == .steps ? .stepCount : .distanceWalkingRunning

            guard let quantityType = HKObjectType.quantityType(forIdentifier: quantityTypeIdentifier) else {
                promise(.failure(HealthStoreError.invalidQuantityType))
                return
            }

            let query = statisticsQueryFactory.collectionQuery(
                quantityType: quantityType,
                quantitySamplePredicate: HKQuery.predicateForSamples(
                    withStart: startDate,
                    end: endDate,
                    options: .init()
                ),
                options: .cumulativeSum,
                anchorDate: anchorDate,
                intervalComponents: DateComponents(minute: intervalInMinutes)
            ) { _, results, _ in
                guard let statsCollection = results else {
                    promise(
                        .success(
                            type == .steps ? .steps([]) : .running([])
                        )
                    )
                    return
                }

                let steps = statsCollection.statistics()
                    .map {
                        Value(
                            date: $0.startDate,
                            count: Int($0.sumQuantity()?.doubleValue(for: type == .steps ? .count() : .meter()) ?? 0)
                        )
                    }
                promise(
                    .success(
                        type == .steps ? .steps(steps) : .running(steps)
                    )
                )
            }

            healthStore.execute(query)
        }
        .eraseToAnyPublisher()
    }

    private var anchorDate: Date? {
        var anchorComponents = calendar.dateComponents([.month, .year], from: calendar.currentDate)
        anchorComponents.hour = 0
        anchorComponents.day = 1
        return calendar.date(from: anchorComponents)
    }
}

enum HealthStoreError: Error {
    case invalidDateTimeframe
    case invalidQuantityType
    case noStepCount
    case permissionNotGranted
}
