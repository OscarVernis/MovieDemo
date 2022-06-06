//
//  GenreString.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 05/06/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import Foundation

enum GenreString: String, Localizable, CaseIterable {
    case Action
    case Adventure
    case Animation
    case Crime
    case Comedy
    case Drama
    case Documentary
    case Family
    case Fantasy
    case History
    case Horror
    case Music
    case Mystery
    case Romance
    case ScienceFiction
    case Thriller
    case TVMovie
    case War
    case Western
    
    var tableName: String { "Genre" }
}
