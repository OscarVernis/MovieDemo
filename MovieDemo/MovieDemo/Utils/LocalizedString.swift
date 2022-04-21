//
//  LocalizedString.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 20/04/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import Foundation

enum LocalizedString: String {
    case serviceLocale = "service-locale"
    case WillAppearMessage = " will appear here."
    case Action = "Action"
    case Acting = "Acting"
    case Adventure = "Adventure"
    case Animation = "Animation"
    case Budget = "Budget"
    case Cast = "Cast"
    case Characters = "Characters"
    case NetworkConnectionError = "Check your network connection."
    case Cinematography = "Cinematography"
    case Comedy = "Comedy"
    case FavoriteError = "Couldn't set favorite! Please try again."
    case WatchListError = "Couldn't add to watchlist! Please try again."
    case RefreshError = "Couldn't refresh content."
    case RatingError = "Couldn't set rating! Please try again."
    case DeleteRatingError = "Couldn't delete rating! Please try again."
    case Country = "Country"
    case Crew = "Crew"
    case Crime = "Crime"
    case Director = "Director"
    case Documentary = "Documentary"
    case Drama = "Drama"
    case Editor = "Editor"
    case Family = "Family"
    case Fantasy = "Fantasy"
    case Favorites = "Favorites"
    case History = "History"
    case Horror = "Horror"
    case Info = "Info"
    case LoginCredentialsError = "Invalid username and/or password."
    case KnownFor = "Known For"
    case LoginError = "Login error. Please try again."
    case LogoutError = "Logout error. Please try again."
    case Movies = "Movies"
    case MoviesBy = "Movies by: %@"
    case EmptyUserWatchlist  = "Movies you add to your Watchlist "
    case EmptyUserFavorites  = "Movies you mark as Favorite "
    case EmptyUserRated  = "Movies you rate "
    case MoviesWith = "Movies with: %@"
    case Music = "Music"
    case Mystery = "Mystery"
    case NowPlaying = "Now Playing"
    case NR = "NR"
    case Overview = "Overview"
    case OriginalLanguage = "Original Language"
    case Popular = "Popular"
    case Rated = "Rated"
    case RecommendedMovies = "Recommended Movies"
    case ReleaseDate = "Release Date"
    case Revenue = "Revenue"
    case Romance = "Romance"
    case ScienceFiction = "Science Fiction"
    case Screenplay = "Screenplay"
    case Status = "Status"
    case Story = "Story"
    case Thriller = "Thriller"
    case TopRated = "Top Rated"
    case TVMovie = "TV Movie"
    case Upcoming = "Upcoming"
    case War = "War"
    case Watchlist = "Watchlist"
    case Western = "Western"
    case Writer = "Writer"

    var localized: String { NSLocalizedString(rawValue, comment: "") }
}

extension String {
    static func localized(_ localizedString: LocalizedString) -> String {
        return localizedString.localized
    }
}
