//
//  SummaryView.swift
//  YourFitnessLevel
//
//  Created by Eduardo Díaz Estrada on 02.06.21.
//

import Foundation
import SwiftUI

struct SummaryView: View {
    @StateObject var state = SummaryViewState()

    init(state: SummaryViewState = SummaryViewState()) {
        _state = StateObject(wrappedValue: state)
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
    }

    var body: some View {
        NavigationView {
            ZStack {
                Color.black.opacity(0.8).edgesIgnoringSafeArea(.all)
                content
                    .padding(.horizontal, 20)
                    .padding(.top)
            }
            .navigationTitle("Your activity")
            .toolbar(content: {
                Text(state.viewData.date)
                    .foregroundColor(.white)
            })
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .onAppear(perform: state.handleViewAppear)
    }

    @ViewBuilder
    private var content: some View {
        if state.viewData.contentType == .empty {
            empty
        } else {
            list
        }
    }

    private var empty: some View {
        VStack(spacing: 30) {
            LottieView(name: state.viewData.requestedBefore ? "loading" : "noData")
                .frame(width: 200, height: 200)

            Text(
                state.viewData.requestedBefore ?
                    "There is no data available at the moment":
                    "We need access to your health data to show your progress"
            )
            .foregroundColor(.white)
            .font(.title3)

            if !state.viewData.requestedBefore {
                Button(action: state.handleRequestAccessToData) {
                    Text("Let's start")
                        .foregroundColor(.white)
                        .font(.body)
                }
            }
            Spacer()
        }
    }

    private var list: some View {
        ScrollView {
            categories
        }
    }

    private var categories: AnyView? {
        guard case let .data(categories) = state.viewData.contentType else {
            return nil
        }

        return ForEach(categories, id: \.title) { category in
            LazyVStack(alignment: .leading) {
                CategoryView(category: category)
            }
        }.asAnyView
    }
}
struct SummaryView_Previews: PreviewProvider {

    static let categories: [Category] = [
        .init(
            achievedDailyGoals: false,
            currentProgress: 50,
            message: "You still need 1000 steps for  next award",
            nextGoal: 100,
            unit: "step",
            title: "Steps",
            samples: []
        ),
        .init(
            achievedDailyGoals: true,
            currentProgress: 50,
            message: "You still need 1000 steps for  next award",
            nextGoal: 5000,
            unit: "km",
            title: "Walking distance",
            samples: []
        ),
        .init(
            achievedDailyGoals: false,
            currentProgress: 0,
            message: "You still need 1000 steps for  next award",
            nextGoal: 100,
            unit: "km",
            title: "Running distance",
            samples: []
        )
    ]

    static var previews: some View {
        Group {
            SummaryView(state: SummaryViewStatePreview())
                .previewDisplayName("Empty state")

            SummaryView(state: SummaryViewStatePreview(contentType: .data(categories)))
                .previewDisplayName("List state")
        }
    }

    class SummaryViewStatePreview: SummaryViewState {
        init(
            date: String = "Wed, 2 June",
            contentType: SummaryViewData.ContentType = .empty,
            requestedBefore: Bool = false
        ) {
            super.init()
            viewData = .init(
                date: date,
                contentType: contentType,
                requestedBefore: requestedBefore
            )
        }
    }
}
