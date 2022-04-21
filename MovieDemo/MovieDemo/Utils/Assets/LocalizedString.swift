//
//  LocalizedString.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 20/04/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import Foundation

enum LocalizedString: String {
    case ServiceLocale
    case WillAppearMessage
    case Action
    case Acting
    case Adventure
    case Animation
    case Budget
    case Cast
    case Characters
    case NetworkConnectionError
    case Cinematography
    case Comedy
    case FavoriteError
    case WatchListError
    case RefreshError
    case RatingError
    case DeleteRatingError
    case Country
    case Crew
    case Crime
    case Director
    case Documentary
    case Drama
    case Editor
    case Family
    case Fantasy
    case Favorites
    case History
    case Horror
    case Info
    case LoginCredentialsError
    case KnownFor
    case LoginError
    case LogoutError
    case Movies
    case MoviesBy
    case EmptyUserWatchlist
    case EmptyUserFavorites
    case EmptyUserRated
    case MoviesWith
    case Music
    case Mystery
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
    case Romance
    case ScienceFiction
    case Screenplay
    case Status
    case Story
    case Thriller
    case TopRated
    case TVMovie
    case Upcoming
    case Videos
    case War
    case Watchlist
    case Western
    case Writer

    var localized: String { NSLocalizedString(rawValue, comment: "") }
}

extension String {
    static func localized(_ localizedString: LocalizedString) -> String {
        return localizedString.localized
    }
}
