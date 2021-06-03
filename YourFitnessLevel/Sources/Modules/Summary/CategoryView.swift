//
//  CategoryView.swift
//  YourFitnessLevel
//
//  Created by Eduardo Díaz Estrada on 02.06.21.
//

import SwiftUI

struct CategoryView: View {
    let category: Category
    @State var displayChart: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(category.title).padding(.padding)
            progressForNextAchievement
            HStack {
                currentProgress
                Spacer()
                goal
            }.padding(.padding)

            actionableButton.padding(.padding)

            if displayChart {
                chart
            }
        }
        .frame(alignment: .topLeading)

        .background(
            Color.yellow
                .cornerRadius(.cornerRadius)
        )
    }

    private var currentProgress: some View {
        VStack {
            Text("Your progress")
            Text("\(category.currentProgress)")
        }
    }

    private var goal: some View {
        VStack {
            Text("Your next goal")
            Text("\(category.goal)")
        }
    }

    private var progressForNextAchievement: some View {
        Color.green
            .frame(maxWidth: .infinity, maxHeight: 25)
            .overlay(GeometryReader { reader in
                Rectangle()
                    .foregroundColor(Color.black)
                    .frame(width: CGFloat(category.currentProgress) / CGFloat(category.goal) * reader.size.width)
            })
    }

    private var actionableButton: some View {
        Button(action: { displayChart.toggle() }) {
            Text(displayChart ? "less" : "more")
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }

    private var chart: some View {
        Chart()
    }
}

struct Chart: View {
    var body: some View {
        VStack {
            Color.clear
                .overlay(GeometryReader { reader in
                    HStack(alignment: .bottom, spacing: 2) {
                        ForEach(0..<48) { hour in
                            VStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.green)
                                    .frame(
                                        width: (reader.size.width - 2 * 48) / 48,
                                        height: CGFloat(hour) * CGFloat.random(in: 1..<5)
                                    )
                            }
                        }
                    }
                })
                .frame(height: 200)
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack {
                Text("00:00").font(.system(size: 8))
                Spacer()
                Text("06:00").font(.system(size: 8))
                Spacer()
                Text("12:00").font(.system(size: 8))
                Spacer()
                Text("18:00").font(.system(size: 8))
                Spacer()
            }.padding(.horizontal, 5)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 250)
    }
}

struct CategoryView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryView(
            category: .init(
                currentProgress: 40,
                goal: 100,
                title: "Steps"
            )
        )
    }
}

private extension CGFloat {
    static let padding: Self = 20
    static let cornerRadius: Self = 8
}
