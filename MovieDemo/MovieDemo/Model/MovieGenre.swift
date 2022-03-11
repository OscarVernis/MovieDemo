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
            return NSLocalizedString("Action", comment: "")
        case .Adventure:
            return NSLocalizedString("Adventure", comment: "")
        case .Animation:
            return NSLocalizedString("Animation", comment: "")
        case .Comedy:
            return NSLocalizedString("Comedy", comment: "")
        case .Crime:
            return NSLocalizedString("Crime", comment: "")
        case .Documentary:
            return NSLocalizedString("Documentary", comment: "")
        case .Drama:
            return NSLocalizedString("Drama", comment: "")
        case .Family:
            return NSLocalizedString("Family", comment: "")
        case .Fantasy:
            return NSLocalizedString("Fantasy", comment: "")
        case .History:
            return NSLocalizedString("History", comment: "")
        case .Horror:
            return NSLocalizedString("Horror", comment: "")
        case .Music:
            return NSLocalizedString("Music", comment: "")
        case .Mystery:
            return NSLocalizedString("Mystery", comment: "")
        case .Romance:
            return NSLocalizedString("Romance", comment: "")
        case .ScienceFiction:
            return NSLocalizedString("Science Fiction", comment: "")
        case .TVMovie:
            return NSLocalizedString("TV Movie", comment: "")
        case .Thriller:
            return NSLocalizedString("Thriller", comment: "")
        case .War:
            return NSLocalizedString("War", comment: "")
        case .Western:
            return NSLocalizedString("Western", comment: "")
        }
    }
    
}
