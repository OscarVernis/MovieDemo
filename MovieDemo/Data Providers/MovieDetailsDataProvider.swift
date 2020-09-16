//
//  MovieDetailsDataProvider.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 10/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import Foundation

class MoviesDetailsDataProvider {
    let movieService = MovieDBService()
    
    var movie:Movie
    
    var recommendedMovies = [Movie]()
    var isFetching = false
    var currentPage = 1
    var totalPages = 1

    var movieUpdateHandler: (() -> Void)?
    var creditsUpdateHandler: (() -> Void)?
    var recommendedMoviesUpdateHandler: (() -> Void)?

    
    init(movie: Movie) {
        self.movie = movie
    }
    
    func fetchMovieDetails() {
        movieService.fetchMovieDetails(movieId: movie.id!) { [weak self] movie, error in
            guard let self = self else { return }

            if error != nil {
                print(error!)
            }
            
            if let movie = movie {
                self.movie = movie
                self.movieUpdateHandler?()
            }
        }
    }
    
    func fetchCredits() {
        movieService.fetchMovieCredits(movieId: movie.id!) { [weak self] cast, crew, error in
            guard let self = self else { return }
            
            if error != nil {
                print(error!)
            }
            
            self.movie.cast = cast
            self.movie.crew = crew
            self.creditsUpdateHandler?()
        }
    }
    
    func fetchRecomendedMovies() {
        if isFetching {
            return
        }
        
        isFetching = true
        
        movieService.fetchRecommendMovies(movieId: movie.id!) { [weak self]  movies, totalPages, error in
            guard let self = self, error == nil else { return }
            
            self.isFetching = false

            if self.currentPage == 1 {
                self.recommendedMovies.removeAll()
            }
            
            self.totalPages = totalPages
            self.currentPage += 1
            
            self.recommendedMovies.append(contentsOf: movies)
            self.recommendedMoviesUpdateHandler?()
        }
    }
    
    func refreshRecommendedMovies() {
        currentPage = 1
        totalPages = 1
        fetchRecomendedMovies()
    }
    
    func fetchNextPageOfRecomendedMovies() {
        if(currentPage >= totalPages) {
            return
        }
        
        currentPage += 1
        fetchRecomendedMovies()
    }
    
}
