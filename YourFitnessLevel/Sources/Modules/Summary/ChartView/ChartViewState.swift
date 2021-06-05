//
//  ChartViewState.swift
//  YourFitnessLevel
//
//  Created by Eduardo Díaz Estrada on 05.06.21.
//

import Combine
import Foundation

class ChartViewState: ObservableObject {
    @Injected private var calendar: CalendarProtocol

    @Published var viewData: ChartViewData = .empty(
            axis: ChartViewData.axis
        )

    private var expectedDates: [Date: ChartViewData.SampleValue] {
        var dates = [Date: ChartViewData.SampleValue]()

        let currentDate = calendar.startOfDay(for: calendar.currentDate)
        for index in 0 ..< (24 * 2) {
            if let date = calendar.date(
                byAdding: .minute,
                value: index * 30,
                to: currentDate,
                wrappingComponents: false
            ) {
                dates[date] = .init(value: 0)
            }
        }

        return dates
    }

    init(samples: [Sample]) {
        guard !samples.isEmpty else {
            return
        }
        update(samples: samples)
    }

    private func update(samples: [Sample]) {
        let maxValue = samples.map { $0.value }.max() ?? 0

        var dates = expectedDates
        samples.forEach {
            if expectedDates[$0.date] != nil {
                dates[$0.date] = .init(value: $0.value)
            }
        }

        viewData = .data(
            axis: ChartViewData.axis,
            maxValue: maxValue,
            samples: dates.sorted(by: { $0.key < $1.key }).compactMap { $0 }.map { $0.value }
        )
    }
}

enum ChartViewData: Equatable {
    case empty(axis: [String])
    case data(axis: [String], maxValue: Double, samples: [SampleValue])

    struct SampleValue: Equatable, Hashable {
        let value: Double
    }
}

private extension ChartViewData {
    static let axis: [String] = ["00:00", "06:00", "12:00", "18:00"]
}
