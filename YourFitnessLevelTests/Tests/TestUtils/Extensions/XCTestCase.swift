//
//  XCTestCase.swift
//  YourFitnessLevelTests
//
//  Created by Eduardo Díaz Estrada on 06.06.21.
//

import SnapshotTesting
import SwiftUI
import XCTest

extension XCTestCase {
    func assertSnapshots<T: View>(
        matching view: T,
        using viewImageConfigs: [ViewImageConfig] = [.iPhoneX],
        file: StaticString = #file,
        testName: String = #function,
        line: UInt = #line
    ) {
        viewImageConfigs.forEach {
            assertSnapshot(
                matching: view,
                as: .image(
                    precision: 0.99,
                    layout: .device(config: $0)
                ),
                file: file,
                testName: testName,
                line: line
            )
        }
    }
}
