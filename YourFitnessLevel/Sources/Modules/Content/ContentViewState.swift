//
//  ContentViewState.swift
//  YourFitnessLevel
//
//  Created by Eduardo Díaz Estrada on 03.06.21.
//

import Combine
import Foundation

class ContentViewState: ObservableObject {
    @Injected private var goalsUseCase: GoalsUseCaseProtocol

    func handleOnAppear() {
        goalsUseCase.fetchGoals()
    }
}
