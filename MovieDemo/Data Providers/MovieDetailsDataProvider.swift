//
//  MovieDetailsDataProvider.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 10/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import Foundation

class MoviesDetailsDataProvider {
    private let movieService = MovieDBService()
    
    var movieViewModel:MovieViewModel!
    
    var isFetching = false
    
    var detailsDidUpdate: (() -> Void)?    
    
    init(movieViewModel: MovieViewModel) {
        self.movieViewModel = movieViewModel
    }
    
    func refresh() {
        fetchMovieDetails()
    }
    
    private func fetchMovieDetails() {
        movieService.fetchMovieDetails(movieId: movieViewModel.id!) { [weak self] movie, error in
            guard let self = self else { return }
            
            if error != nil {
                print(error!)
            }
            
            if let movie = movie {
                self.movieViewModel.updateMovie(movie)
                self.detailsDidUpdate?()
            }
        }
    }
    
}
