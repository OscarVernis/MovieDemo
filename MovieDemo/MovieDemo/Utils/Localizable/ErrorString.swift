//
//  ErrorString.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 05/06/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import Foundation

enum ErrorString: String, Localizable {
    case LoginCredentialsError
    case NetworkConnectionError
    case FavoriteError
    case WatchListError
    case RefreshError
    case RatingError
    case DeleteRatingError
    case LoginError
    case LogoutError
    
    var localized: String { NSLocalizedString(rawValue, comment: "") }
}
