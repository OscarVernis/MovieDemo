//
//  UserListDetailRouter.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 26/07/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import Foundation

protocol UserListDetailRouter: ErrorHandlingRouter {
    func showMovieDetail(movie: MovieViewModel, animated: Bool)
}

extension UserListDetailRouter {
    func showMovieDetail(movie: MovieViewModel, animated: Bool = true) {
        showMovieDetail(movie: movie, animated: animated)
    }
}
