//
//  PersonDetailRouter.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 07/07/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import Foundation

protocol PersonDetailRouter {
    func showMovieDetail(movie: MovieViewModel, animated: Bool)
    func handle(error: UserFacingError, shouldDismiss: Bool)

}

extension PersonDetailRouter {
    func showMovieDetail(movie: MovieViewModel, animated: Bool = true) {
        showMovieDetail(movie: movie, animated: animated)
    }
    
    func handle(error: UserFacingError, shouldDismiss: Bool = false) {
        handle(error: error, shouldDismiss: shouldDismiss)
    }
    
}
