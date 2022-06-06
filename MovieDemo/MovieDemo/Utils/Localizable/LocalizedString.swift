//
//  LocalizedString.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 20/04/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import Foundation

protocol Localizable {
    var localized: String { get }
}

enum LocalizedString: String, Localizable {
    case ServiceLocale
    case WillAppearMessage
    case Acting
    case Budget
    case Cast
    case Characters
    case Cinematography
    case Country
    case Crew
    case Director
    case Editor
    case Favorites
    case Info
    case KnownFor
    case Movies
    case MoviesBy
    case EmptyUserWatchlist
    case EmptyUserFavorites
    case EmptyUserRated
    case MoviesWith
    case Music
    case NowPlaying
    case NR
    case Overview
    case OriginalLanguage
    case OriginalTitle
    case Popular
    case Rated
    case RecommendedMovies
    case ReleaseDate
    case Revenue
    case Screenplay
    case Status
    case Story
    case TopRated
    case Upcoming
    case Videos
    case Watchlist
    case Writer

    var localized: String { NSLocalizedString(rawValue, comment: "") }
}

extension String {
    static func localized(_ localizedString: Localizable) -> String {
        return localizedString.localized
    }
    
    static func localized(_ localizedString: LocalizedString) -> String {
        return localizedString.localized
    }
}
