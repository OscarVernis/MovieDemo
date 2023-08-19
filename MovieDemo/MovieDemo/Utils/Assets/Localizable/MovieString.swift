//
//  MovieString.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 05/06/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import Foundation

enum MovieString: String, Localizable, CaseIterable {
    case Cast
    case Crew
    case NR
    case OriginalLanguage
    case OriginalTitle
    case ReleaseDate
    case Revenue
    case Status
    case Country
    case Budget
    case Videos
    case Info
    case RecommendedMovies
    case Overview
    case Trailer
    case All
    case OpenOnYoutube

    var tableName: String { "Movie" }
}
