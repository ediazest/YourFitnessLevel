//
//  AwardsUseCase.swift
//  YourFitnessLevel
//
//  Created by Eduardo Díaz Estrada on 03.06.21.
//

import Combine
import Foundation

protocol AwardsUseCaseProtocol {
    var awards: AnyPublisher<[Goal], Never> { get }
}

class AwardsUseCase: AwardsUseCaseProtocol {
    @Injected private var goalsUseCase: GoalsUseCaseProtocol

    lazy var awards: AnyPublisher<[Goal], Never> = goalsUseCase.goals

}
