//
//  GoalResponse.swift
//  YourFitnessLevel
//
//  Created by Eduardo Díaz Estrada on 03.06.21.
//

import Foundation

struct GoalResponse: Decodable, Equatable {
    let items: [GoalDTO]
    let nextPageToken: String
}

struct GoalDTO: Decodable, Equatable {
    let identifier: String
    let title: String
    let description: String
    let type: String
    let goal: Int
    let reward: RewardDTO

    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case title
        case description
        case type
        case goal
        case reward
    }
}

struct RewardDTO: Decodable, Equatable {
    let trophy: String
    let points: Int
}
