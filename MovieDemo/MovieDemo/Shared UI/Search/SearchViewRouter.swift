//
//  SearchViewRouter.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 08/07/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import Foundation

protocol SearchViewRouter: ErrorHandlingRouter {
    func showMovieDetail(movie: MovieViewModel, animated: Bool)
    func showPersonProfile(_ viewModel: PersonViewModel, animated: Bool)
}

extension SearchViewRouter {
    func showMovieDetail(movie: MovieViewModel, animated: Bool = true) {
        showMovieDetail(movie: movie, animated: animated)
    }
    
    func showPersonProfile(_ viewModel: PersonViewModel, animated: Bool = true) {
        showPersonProfile(viewModel, animated: animated)
    }
}
