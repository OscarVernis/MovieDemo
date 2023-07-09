//
//  MovieDetailStore.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 07/07/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import Foundation
import Combine

class MovieDetailStore: ObservableObject {
    @Published var movie: MovieViewModel
    private var movieService: MovieDetailsLoader?
    private let userStateService: UserStateService?
        
    init(movie: MovieViewModel, movieService: MovieDetailsLoader? = nil, userStateService: UserStateService? = nil) {
        self.movie = movie
        self.movieService = movieService
        self.userStateService = userStateService
        self.isLoading = (movieService != nil)
    }

    //MARK: - Get Movie Details
    @Published var error: Error? = nil
    private(set) var isLoading = false
    
    func refresh() {
        guard let movieService else { return }
        
        isLoading = true
        
        movieService.getMovieDetails(movieId: movie.id)
            .assignError(to: \.error, on: self)
            .handleEvents(receiveCompletion: { [weak self] _ in
                self?.isLoading = false
            })
            .map(MovieViewModel.init)
            .assign(to: &$movie)
    }
    
    //MARK: - User Actions
    var showUserActions: Bool {
        return userStateService != nil
    }
    
    @MainActor
    func markAsFavorite(_ favorite: Bool, completionHandler: @escaping (Bool) -> Void) {
        guard let userStateService else { return }
        
        Task {
            do {
                try await userStateService.markAsFavorite(favorite, movieId: movie.id)
                movie.setFavorite(favorite)
                completionHandler(true)
            } catch {
                completionHandler(false)
            }
        }
        
    }
    
    @MainActor
    func addToWatchlist(_ watchlist: Bool, completionHandler: @escaping (Bool) -> Void) {
        guard let userStateService else { return }

        Task {
            do {
                try await userStateService.addToWatchlist(watchlist, movieId: movie.id)
                movie.setWatchlist(watchlist)
                completionHandler(true)
            } catch {
                completionHandler(false)
            }
        }
    }
    
    @MainActor
    func rate(_ rating: Int, completionHandler: @escaping (Bool) -> Void) {
        guard let userStateService else { return }

        //ViewModel receives rating as 0 to 100, but service receives 0.5 to 10 in multiples of 0.5
        var adjustedRating:Float = Float(rating) / 10
        adjustedRating = (adjustedRating / 0.5).rounded(.down) * 0.5
        
        if adjustedRating > 10 {
            adjustedRating = 10
        }
        if adjustedRating < 0.5 {
            adjustedRating = 0.5
        }
        
        Task {
            do {
                try await userStateService.rateMovie(adjustedRating, movieId: movie.id)
                movie.setUserRating(adjustedRating)
                movie.setWatchlist(false) //Server removes movie from watchlist when rating
                completionHandler(true)
            } catch {
                completionHandler(false)
            }
        }
        
    }
    
    @MainActor
    func deleteRate(completionHandler: @escaping (Bool) -> Void) {
        guard let userStateService else { return }
        
        Task {
            do {
                try await userStateService.deleteRate(movieId: movie.id)
                movie.setUserRating(nil)
                completionHandler(true)
            } catch {
                completionHandler(false)
            }
        }
    }
    
}
