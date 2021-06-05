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
            Text("You still need 1000 steps for  next award")
                .padding(.horizontal)

            actionableButton.padding(.padding)

            if displayChart {
                chart
            }
        }
        .padding(.top)
        .frame(alignment: .leading)
        .background(Color.white.opacity(0.3))
        .cornerRadius(8)
    }

    private var currentProgress: some View {
        HStack {
            Text("\(category.currentProgress)")
            Text("steps")
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
            }).clipShape(RoundedRectangle(cornerSize: .init(width: 10, height: 10)))
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
                achievedDailyGoals: true,
                currentProgress: 40,
                nextGoal: 100,
                title: "Steps"
            )
        )
    }
}

private extension CGFloat {
    static let padding: Self = 20
    static let cornerRadius: Self = 8
}

private extension Color {
    static let redCalories = Color(red: 217 / 255, green: 48 / 255, blue: 48 / 255)

    static let blackOff = Color.black.opacity(0.6)
}
