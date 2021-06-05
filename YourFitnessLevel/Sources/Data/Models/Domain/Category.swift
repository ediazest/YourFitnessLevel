//
//  Category.swift
//  YourFitnessLevel
//
//  Created by Eduardo Díaz Estrada on 02.06.21.
//

import Foundation

struct Category: Equatable {
    let achievedDailyGoals: Bool
    let currentProgress: Int
    let message: String
    let nextGoal: Int
    let unit: String
    let title: String
    let samples: [Sample]
}

struct Sample: Equatable {
    let date: Date
    let value: Double
}
