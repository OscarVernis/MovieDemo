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
    var creditsDidUpdate: (() -> Void)?
    var recommendedMoviesDidUpdate: (() -> Void)?
    
    
    init(movieViewModel: MovieViewModel) {
        self.movieViewModel = movieViewModel
    }
    
    func refresh() {
        fetchMovieDetails()
        fetchCredits()
        fetchRecomendedMovies()
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
    
    private func fetchCredits() {
        movieService.fetchMovieCredits(movieId: movieViewModel.id!) { [weak self] cast, crew, error in
            guard let self = self else { return }
            
            if error != nil {
                print(error!)
            }
            
            self.movieViewModel.cast = cast!
            self.movieViewModel.crew = crew!
            self.creditsDidUpdate?()
        }
    }
    
    private func fetchRecomendedMovies() {
        if isFetching {
            return
        }
        
        isFetching = true
        
        movieService.fetchRecommendMovies(movieId: movieViewModel.id!) { [weak self]  movies, totalPages, error in
            guard let self = self, error == nil else { return }
            
            self.isFetching = false
            
            self.movieViewModel.recommendedMovies = movies
            self.recommendedMoviesDidUpdate?()
        }
    }
    
    private func refreshRecommendedMovies() {
        fetchRecomendedMovies()
    }
    
}
