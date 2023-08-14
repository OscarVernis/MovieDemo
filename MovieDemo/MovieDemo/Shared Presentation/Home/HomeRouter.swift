//
//  HomeRouter.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 07/07/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import Foundation

protocol HomeRouter: ErrorHandlingRouter {
    func showMovieDetail(movie: MovieViewModel, animated: Bool)
    
    func showNowPlaying()
    func showUpcoming()
    func showPopular()
    func showTopRated()
}

extension HomeRouter {
    func showMovieDetail(movie: MovieViewModel, animated: Bool = true) {
        showMovieDetail(movie: movie, animated: animated)
    }
}
