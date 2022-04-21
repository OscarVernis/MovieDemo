//
//  MovieGenre.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 15/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import Foundation

enum MovieGenre: Int, Codable {
    case Action = 28
    case Adventure = 12
    case Animation = 16
    case Comedy = 35
    case Crime = 80
    case Documentary = 99
    case Drama = 18
    case Family = 10751
    case Fantasy = 14
    case History = 36
    case Horror = 27
    case Music = 10402
    case Mystery = 9648
    case Romance = 10749
    case ScienceFiction = 878
    case TVMovie = 10770
    case Thriller = 53
    case War = 10752
    case Western = 37
    
    func string() -> String {
        switch self {
        case .Action:
            return .localized(.Action)
        case .Adventure:
            return .localized(.Adventure)
        case .Animation:
            return .localized(.Animation)
        case .Comedy:
            return .localized(.Comedy)
        case .Crime:
            return .localized(.Crime)
        case .Documentary:
            return .localized(.Documentary)
        case .Drama:
            return .localized(.Drama)
        case .Family:
            return .localized(.Family)
        case .Fantasy:
            return .localized(.Fantasy)
        case .History:
            return .localized(.History)
        case .Horror:
            return .localized(.Horror)
        case .Music:
            return .localized(.Music)
        case .Mystery:
            return .localized(.Mystery)
        case .Romance:
            return .localized(.Romance)
        case .ScienceFiction:
            return .localized(.ScienceFiction)
        case .TVMovie:
            return .localized(.TVMovie)
        case .Thriller:
            return .localized(.Thriller)
        case .War:
            return .localized(.War)
        case .Western:
            return .localized(.Western)
        }
    }
    
}
