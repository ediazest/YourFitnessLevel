//
//  HealthDataRepositoryTests.swift
//  YourFitnessLevelTests
//
//  Created by Eduardo Díaz Estrada on 06.06.21.
//

import Combine
import HealthKit
import XCTest
@testable import YourFitnessLevel

class HealthDataRepositoryTests: XCTestCase {

    private let mockCalendar = CalendarMock()
    private let mockHealthStore = HealthStoreMock()
    private let mockStorage = UserDefaultStorageMock()
    private let mockQueryFactory = StatisticsQueryFactoryMock()

    private var subscriptions: Set<AnyCancellable> = []

    private var sut: HealthDataRepository!

    override func setUp() {
        super.setUp()
        createTestDependencies(
            mockCalendar,
            mockHealthStore,
            mockStorage,
            mockQueryFactory
        )

        sut = .init()
    }

    override func tearDown() {
        removeTestDependencies()
        super.tearDown()
    }

    func test_isAvailable_isForwardedFromHealthStore() {

        mockHealthStore.isHealthDataAvailable = false
        XCTAssertFalse(sut.isAvailable)

        mockHealthStore.isHealthDataAvailable = true
        XCTAssertTrue(sut.isAvailable)
    }

    func test_fetchActivityData_askForPermissionAndFails_doesntStoreFlag_emitsPermissionNotGranted() {
        let startDate = Date()
        let endDate = Date()
        let intervalInMinutes: Int = 30
        let type: ActivityTypeRequest = .steps

        var result: Error?

        sut.fetchActivityData(
            startDate: startDate,
            endDate: endDate,
            intervalInMinutes: intervalInMinutes,
            type: type
        ).sink(
            receiveCompletion: {
                guard case let .failure(error) = $0 else {
                    XCTFail("It should not complete")
                    return
                }
                result = error
            },
            receiveValue: { _ in }
        )
        .store(in: &subscriptions)

        mockHealthStore.authorizationCompletionClosure?(false, MockError.some)

        XCTAssertEqual(mockStorage.calls, [])
        XCTAssertEqual(mockHealthStore.calls, [.requestAuthorization(
            [],
            [
                HKObjectType.quantityType(forIdentifier: .stepCount)!,
                HKObjectType.workoutType()
            ]
        )])
        XCTAssertEqual(result?.localizedDescription, MockError.some.localizedDescription)
    }

    func test_fetchActivityData_askForPermissionAndFailsWithoutError_storesFlag_emitsPermissionNotGranted() {
        let startDate = Date()
        let endDate = Date()
        let intervalInMinutes: Int = 30
        let type: ActivityTypeRequest = .steps

        var result: Error?

        sut.fetchActivityData(
            startDate: startDate,
            endDate: endDate,
            intervalInMinutes: intervalInMinutes,
            type: type
        ).sink(
            receiveCompletion: {
                guard case let .failure(error) = $0 else {
                    XCTFail("It should not complete")
                    return
                }
                result = error
            },
            receiveValue: { _ in }
        )
        .store(in: &subscriptions)

        mockHealthStore.authorizationCompletionClosure?(false, nil)

        XCTAssertEqual(mockStorage.calls, [.set("health_requested_key")])
        XCTAssertEqual(mockHealthStore.calls, [.requestAuthorization(
            [],
            [
                HKObjectType.quantityType(forIdentifier: .stepCount)!,
                HKObjectType.workoutType()
            ]
        )])
        XCTAssertEqual(result?.localizedDescription, HealthStoreError.permissionNotGranted.localizedDescription)
    }

    func test_fetchActivityData_emitsInvalidTimeframe() {
        let startDate = Date()
        let endDate = Date()
        let currentDate = Date()
        let components = DateComponents()
        let expectedComponents = DateComponents(day: 1, hour: 0)

        let intervalInMinutes: Int = 30
        let type: ActivityTypeRequest = .steps

        var result: Error?

        sut.fetchActivityData(
            startDate: startDate,
            endDate: endDate,
            intervalInMinutes: intervalInMinutes,
            type: type
        ).sink(
            receiveCompletion: {
                guard case let .failure(error) = $0 else {
                    XCTFail("It should not complete")
                    return
                }
                result = error
            },
            receiveValue: { _ in }
        )
        .store(in: &subscriptions)

        mockCalendar.currentDate = currentDate
        mockCalendar.returnedDateComponents = components
        mockHealthStore.authorizationCompletionClosure?(true, nil)

        XCTAssertEqual(mockStorage.calls, [.set("health_requested_key")])
        XCTAssertEqual(mockCalendar.calls, [
            .dateComponents([.month, .year], currentDate),
            .date(expectedComponents)
        ])
        XCTAssertEqual(mockHealthStore.calls, [.requestAuthorization(
            [],
            [
                HKObjectType.quantityType(forIdentifier: .stepCount)!,
                HKObjectType.workoutType()
            ]
        )])
        XCTAssertEqual(result?.localizedDescription, HealthStoreError.invalidDateTimeframe.localizedDescription)
    }

    func test_fetchStepsActivityData_emitsEmptyActivity_whenNoSteps() {
        let startDate = Date()
        let endDate = Date()
        let currentDate = Date()
        let components = DateComponents()
        let expectedComponents = DateComponents(day: 1, hour: 0)

        let intervalInMinutes: Int = 30
        let type: ActivityTypeRequest = .steps

        let query: HKStatisticsCollectionQuery = .init(
            quantityType: HKObjectType.quantityType(forIdentifier: .stepCount)!,
            quantitySamplePredicate: HKQuery.predicateForSamples(
                withStart: startDate,
                end: endDate,
                options: .init()
            ),
            options: .cumulativeSum,
            anchorDate: currentDate,
            intervalComponents: DateComponents(minute: intervalInMinutes)
        )

        var result: Activity?

        mockCalendar.currentDate = currentDate
        mockCalendar.returnedDateComponents = components
        mockCalendar.returnedDate = currentDate
        mockQueryFactory.returnedQuery = query

        sut.fetchActivityData(
            startDate: startDate,
            endDate: endDate,
            intervalInMinutes: intervalInMinutes,
            type: type
        ).sink(
            receiveCompletion: {
                guard case .finished = $0 else {
                    XCTFail("It should not fail")
                    return
                }
            },
            receiveValue: { result = $0 }
        )
        .store(in: &subscriptions)

        mockHealthStore.authorizationCompletionClosure?(true, nil)
        mockQueryFactory.queryHandler?(query, nil, MockError.some)

        XCTAssertEqual(mockStorage.calls, [.set("health_requested_key")])
        XCTAssertEqual(mockCalendar.calls, [
            .dateComponents([.month, .year], currentDate),
            .date(expectedComponents)
        ])
        XCTAssertEqual(mockHealthStore.calls, [
            .requestAuthorization(
                [], [
                    HKObjectType.quantityType(forIdentifier: .stepCount)!,
                    HKObjectType.workoutType()
                ]
            ),
            .excute(query)
        ])

        XCTAssertTrue(result?.isSteps == true)
        if case let .steps(steps) = result {
            XCTAssertEqual(steps, [])
        }
        XCTAssertEqual(mockQueryFactory.calls, [.collection(
                                                    quantityType: query.objectType as! HKQuantityType,
                                                    quantitySamplePredicate: query.predicate,
                                                    options: query.options,
                                                    anchorDate: query.anchorDate,
                                                    intervalComponents: query.intervalComponents)]
        )
    }
}
