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
    case logoutError
    
    var errorDescription: String? {
        switch self {
        case .refreshError:
            return .localized(.RefreshError)
        case .favoriteError:
            return .localized(.FavoriteError)
        case .watchlistError:
            return .localized(.WatchListError)
        case .ratingError:
            return .localized(.RatingError)
        case .deleteRatingError:
            return .localized(.DeleteRatingError)
        case .logoutError:
            return .localized(.LogoutError)

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
        case .refreshError, .logoutError:
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
        case .refreshError, .logoutError:
            return nil
        }
    }
    
}
