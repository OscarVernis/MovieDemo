//
//  HomeRouter.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 07/07/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import Foundation

protocol HomeRouter {
    func showUserProfile()
    func showMovieList(title: String, dataProvider: MoviesProvider)
    func showMovieDetail(movie: MovieViewModel)
    func searchViewController() -> UIViewController
}
