//
//  UserProfileRouter.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 08/07/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import Foundation

protocol UserProfileRouter {
    func logout()
    func showMovieDetail(movie: MovieViewModel, animated: Bool)
    func showUserFavorites()
    func showUserWatchlist()
    func showUserRated()

    func handle(error: UserFacingError, shouldDismiss: Bool)
}

extension UserProfileRouter {
    func showMovieDetail(movie: MovieViewModel, animated: Bool = true) {
        showMovieDetail(movie: movie, animated: animated)
    }
    
    func handle(error: UserFacingError, shouldDismiss: Bool = false) {
        handle(error: error, shouldDismiss: shouldDismiss)
    }
    
}
