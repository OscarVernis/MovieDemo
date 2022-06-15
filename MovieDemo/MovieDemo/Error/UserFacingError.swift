//
//  UserFacingError.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 05/06/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import Foundation
import UIKit

enum UserFacingError: LocalizedError {
    case refreshError
    case favoriteError
    case watchlistError
    case ratingError
    case deleteRatingError
    case loginError
    case logoutError
    
    var errorDescription: String? {
        switch self {
        case .refreshError:
            return .localized(ErrorString.RefreshError)
        case .favoriteError:
            return .localized(ErrorString.FavoriteError)
        case .watchlistError:
            return .localized(ErrorString.WatchListError)
        case .ratingError:
            return .localized(ErrorString.RatingError)
        case .deleteRatingError:
            return .localized(ErrorString.DeleteRatingError)
        case .loginError:
            return .localized(ErrorString.LoginError)
        case .logoutError:
            return .localized(ErrorString.LogoutError)

        }
    }
    
    var alertImage: UIImage? {
        switch self {
        case .favoriteError:
            return .asset(.heart)
        case .watchlistError:
            return .asset(.bookmark)
        case .ratingError, .deleteRatingError:
            return .asset(.star)
        case .refreshError, .loginError,.logoutError:
            return nil
        }
    }
    
    var alertColor: UIColor? {
        switch self {
        case .favoriteError:
            return .asset(.FavoriteColor)
        case .watchlistError:
            return .asset(.WatchlistColor)
        case .ratingError, .deleteRatingError:
            return .asset(.RatingColor)
        case .refreshError, .loginError,.logoutError:
            return nil
        }
    }
    
}
