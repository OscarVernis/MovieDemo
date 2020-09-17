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
    
    var movie:Movie 
    
    var recommendedMovies = [Movie]()
    var isFetching = false
    var currentPage = 1
    var totalPages = 1

    var detailsDidUpdate: (() -> Void)?
    var creditsDidUpdate: (() -> Void)?
    var recommendedMoviesDidUpdate: (() -> Void)?

    
    init(movie: Movie) {
        self.movie = movie
    }
    
    func refresh() {
        currentPage = 1
        totalPages = 1
        
        fetchMovieDetails()
        fetchCredits()
        fetchRecomendedMovies()
    }
    
    private func fetchMovieDetails() {
        movieService.fetchMovieDetails(movieId: movie.id!) { [weak self] movie, error in
            guard let self = self else { return }

            if error != nil {
                print(error!)
            }
            
            if let movie = movie {
                self.movie = movie
                self.detailsDidUpdate?()
            }
        }
    }
    
    private func fetchCredits() {
        movieService.fetchMovieCredits(movieId: movie.id!) { [weak self] cast, crew, error in
            guard let self = self else { return }
            
            if error != nil {
                print(error!)
            }
            
            self.movie.cast = cast
            self.movie.crew = crew
            self.creditsDidUpdate?()
        }
    }
    
    private func fetchRecomendedMovies() {
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
            self.recommendedMoviesDidUpdate?()
        }
    }
    
    private func refreshRecommendedMovies() {
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
