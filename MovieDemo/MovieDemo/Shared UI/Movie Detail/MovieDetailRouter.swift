//
//  MovieDetailRouter.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 07/07/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import Foundation
import UIKit

protocol MovieDetailRouter {
    func showMovieDetail(movie: MovieViewModel, animated: Bool)
    func showCrewCreditList(credits: [CrewCreditViewModel], animated: Bool)
    func showCastCreditList(credits: [CastCreditViewModel], animated: Bool)
    func showRecommendedMovies(for: Int)
    func showPersonProfile(_ viewModel: PersonViewModel, animated: Bool)
    func showMovieRatingView(store: MovieDetailStore, updateHandler: @escaping () -> ())
    
    func handle(error: UserFacingError, shouldDismiss: Bool)
    
}

extension MovieDetailRouter {
    func showMovieDetail(movie: MovieViewModel, animated: Bool = true) {
        showMovieDetail(movie: movie, animated: animated)
    }
    
    func showCrewCreditList(credits: [CrewCreditViewModel], animated: Bool = true) {
        showCrewCreditList(credits: credits, animated: animated)
    }
    
    func showCastCreditList(credits: [CastCreditViewModel], animated: Bool = true) {
        showCastCreditList(credits: credits, animated: animated)
    }
    
    func showPersonProfile(_ viewModel: PersonViewModel, animated: Bool = true) {
        showPersonProfile(viewModel, animated: animated)
    }
    
    func handle(error: UserFacingError, shouldDismiss: Bool = false) {
        handle(error: error, shouldDismiss: shouldDismiss)
    }
    
}

