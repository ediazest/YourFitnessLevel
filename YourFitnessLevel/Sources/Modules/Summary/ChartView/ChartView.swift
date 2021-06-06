//
//  ChartView.swift
//  YourFitnessLevel
//
//  Created by Eduardo Díaz Estrada on 05.06.21.
//

import Foundation
import SwiftUI

struct ChartView: View {
    @StateObject var state: ChartViewState

    init(state: ChartViewState) {
        _state = StateObject(wrappedValue: state)
    }

    var body: some View {
        content
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: .chartHeight)
    }

    @ViewBuilder
    private var content: some View {
        switch state.viewData {
        case let .empty(axis):
            emptyView(axis: axis)
        case let .data(axis, maxValue, samples):
            chartView(axis: axis, maxValue: maxValue, samples: samples)
        }
    }

    private func chartView(axis: [String], maxValue: Double, samples: [ChartViewData.SampleValue]) -> some View {
        VStack {
            ZStack(alignment: .bottom) {
                Color.clear
                    .overlay(GeometryReader { reader in
                        HStack(alignment: .bottom, spacing: 2) {
                            ForEach(samples, id: \.self) { sample in
                                VStack {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.redCalories)
                                        .frame(
                                            width: (reader.size.width - 2 * 48) / 48,
                                            height: CGFloat(sample.value) * .maxBarHeight / CGFloat(maxValue)
                                        )
                                }
                            }
                        }.frame(maxHeight: .infinity, alignment: .bottom)
                    })
                    .frame(height: .maxBarHeight)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Divider()
            }

            axisView(axis)
        }
    }

    private func emptyView(axis: [String]) -> some View {
        VStack {

            Text("No chart data available")
                .frame(height: .maxBarHeight / 2)
                .font(.caption)

            Divider()
            axisView(axis)
        }
    }

    private func axisView(_ axis: [String]) -> some View {
        HStack {
            ForEach(axis, id: \.self) {
                Text($0).font(.system(size: 8))
                Spacer()
            }
        }.padding(.horizontal, 5)
    }
}

private extension CGFloat {
    static let maxBarHeight: Self = 180
    static let chartHeight: Self = 200
}
