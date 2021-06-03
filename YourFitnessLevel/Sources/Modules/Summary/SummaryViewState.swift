//
//  SummaryViewState.swift
//  YourFitnessLevel
//
//  Created by Eduardo Díaz Estrada on 02.06.21.
//

import Combine
import Foundation

class SummaryViewState: ObservableObject {
    @Published var viewData: SummaryViewData = .init(date: "Wed 2, June", contentType: .empty)
    @Injected private var awardsUseCase: AwardsUseCaseProtocol

    private var subscriptions: [AnyCancellable] = []

    func handleViewAppear() {
        awardsUseCase.awards
            .sink {
                print($0)
            }
            .store(in: &subscriptions)
    }

    func handleRequestAccessToData() {
        viewData = .init(
            date: "Wed 2, Jun",
            contentType: .data([
                .init(currentProgress: 50, goal: 100, title: "Steps"),
                .init(currentProgress: 50, goal: 5000, title: "Walking distance"),
                .init(currentProgress: 0, goal: 100, title: "Running distance")
            ])
        )
    }
}

struct SummaryViewData: Equatable {
    let date: String
    let contentType: ContentType

    enum ContentType: Equatable {
        case empty
        case data([Category])
    }
}
