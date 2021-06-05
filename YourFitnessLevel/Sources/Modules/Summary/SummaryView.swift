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

    var body: some View {
        content
            .padding(.horizontal, 20)
            .padding(.top)
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
        VStack {
            header
            Spacer()
            Text("We need access to health date to show your progress")
                .foregroundColor(.white)
            Button(action: state.handleRequestAccessToData) {
                Text("gooo")
                    .foregroundColor(.white)
            }
            Spacer()
        }
    }

    private var list: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                header
                Text("5 min ago")
                    .foregroundColor(.white)
                categories
            }
        }
    }

    private var categories: AnyView? {
        guard case let .data(categories) = state.viewData.contentType else {
            return nil
        }

        return ForEach(categories, id: \.title) { category in
            VStack {
                CategoryView(category: category)
            }
        }.asAnyView
    }

    private var header: some View {
        HStack {
            Text("Summary")
                .foregroundColor(.white)
            Spacer()
            Text(state.viewData.date)
                .foregroundColor(.white)
        }.frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct SummaryView_Previews: PreviewProvider {

    static let categories: [Category] = [
        .init(currentProgress: 50, goal: 100, title: "Steps"),
        .init(currentProgress: 50, goal: 5000, title: "Walking distance"),
        .init(currentProgress: 0, goal: 100, title: "Running distance")
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
            contentType: SummaryViewData.ContentType = .empty
        ) {
            super.init()
            viewData = .init(date: date, contentType: contentType)
        }
    }
}
