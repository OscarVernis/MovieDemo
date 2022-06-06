//
//  UserString.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 05/06/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import Foundation

enum UserString: String, Localizable, CaseIterable {
    case Favorites
    case Watchlist
    case Rated
    case WillAppearMessage
    case EmptyUserWatchlist
    case EmptyUserFavorites
    case EmptyUserRated

    var localized: String { NSLocalizedString(rawValue, comment: "") }
}
