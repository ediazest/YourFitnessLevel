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
            Label(category.title, image: "iconCalories")
                .foregroundColor(.redCalories)
                .padding(.horizontal)

            currentProgress

            progressForNextAchievement.padding(.horizontal)
            Text(category.message)
                .padding(.horizontal)

            actionableButton.padding(.padding)

            if displayChart {
                ChartView(samples: category.samples)
            }
        }
        .padding(.vertical)
        .frame(alignment: .leading)
        .background(Color.white.opacity(0.3))
        .cornerRadius(8)
    }

    private var currentProgress: some View {
        HStack {
            Text("\(category.currentProgress)")
            Text(category.unit)
            if let nextGoal = category.nextGoal {
                Spacer()
                Text("\(nextGoal) \(category.unit)")
                    .foregroundColor(.blackOff)
            }
        }
        .padding(.horizontal)
    }

    private var progressForNextAchievement: some View {
        Color.blackOff
            .frame(maxWidth: .infinity)
            .frame(height: 35)
            .overlay(GeometryReader { reader in
                Rectangle()
                    .foregroundColor(.redCalories)
                    .frame(width: CGFloat(category.currentProgress) / CGFloat(category.nextGoal) * reader.size.width)
            })
            .clipShape(RoundedRectangle(cornerSize: .init(width: 10, height: 10)))
    }

    private var actionableButton: some View {
        Button(
            action: { displayChart.toggle() },
            label: {
                Text(displayChart ? "less" : "more")
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .animation(nil)
            }
        )
    }
}

struct CategoryView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryView(
            category: .init(
                achievedDailyGoals: true,
                currentProgress: 40,
                message: "You still need 1000 steps for  next award",
                nextGoal: 100,
                unit: "steps",
                title: "Steps",
                samples: []
            )
        )
    }
}

private extension CGFloat {
    static let padding: Self = 20
    static let cornerRadius: Self = 8
}
