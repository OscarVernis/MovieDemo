//
//  MovieGenre.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 15/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import Foundation

enum MovieGenre: Int {
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
            return .localized(GenreString.Action)
        case .Adventure:
            return .localized(GenreString.Adventure)
        case .Animation:
            return .localized(GenreString.Animation)
        case .Comedy:
            return .localized(GenreString.Comedy)
        case .Crime:
            return .localized(GenreString.Crime)
        case .Documentary:
            return .localized(GenreString.Documentary)
        case .Drama:
            return .localized(GenreString.Drama)
        case .Family:
            return .localized(GenreString.Family)
        case .Fantasy:
            return .localized(GenreString.Fantasy)
        case .History:
            return .localized(GenreString.History)
        case .Horror:
            return .localized(GenreString.Horror)
        case .Music:
            return .localized(GenreString.Music)
        case .Mystery:
            return .localized(GenreString.Mystery)
        case .Romance:
            return .localized(GenreString.Romance)
        case .ScienceFiction:
            return .localized(GenreString.ScienceFiction)
        case .TVMovie:
            return .localized(GenreString.TVMovie)
        case .Thriller:
            return .localized(GenreString.Thriller)
        case .War:
            return .localized(GenreString.War)
        case .Western:
            return .localized(GenreString.Western)
        }
    }
    
}
