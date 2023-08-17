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
    @Published var watchProviders: WatchProvidersViewModel? = nil
    
    private var movieService: MovieDetailsService?
    private let userStateService: UserStateService?
    private let watchProvidersService: WatchProvidersService?
            
    init(movie: MovieViewModel, movieService: @autoclosure @escaping MovieDetailsService, userStateService: UserStateService? = nil, watchProvidersService: WatchProvidersService? = nil) {
        self.movie = movie
        self.movieService = movieService
        self.userStateService = userStateService
        self.watchProvidersService = watchProvidersService
    }
    
    init(movie: MovieViewModel, movieService: MovieDetailsService? = nil, userStateService: UserStateService? = nil, watchProvidersService: WatchProvidersService? = nil) {
        self.movie = movie
        self.movieService = movieService
        self.userStateService = userStateService
        self.watchProvidersService = watchProvidersService
    }

    //MARK: - Get Movie Details
    @Published var error: Error? = nil
    private(set) var isLoading = false
    var hasWatchProviders: Bool {
        guard let watchProviders else { return false }
        return !watchProviders.countries.isEmpty
    }
    
    func refresh() {
        guard let movieService else { return }
        
        isLoading = true
        
        movieService()
            .assignError(to: \.error, on: self)
            .onCompletion { self.isLoading = false }
            .map(MovieViewModel.init)
            .assign(to: &$movie)
        
        if let watchProvidersService {
            watchProvidersService()
                .ignoreError()
                .map(WatchProvidersViewModel.init)
                .assign(to: &$watchProviders)
        }

    }
    
    //MARK: - User Actions
    var showUserActions: Bool {
        return userStateService != nil
    }
    
    func markAsFavorite(_ favorite: Bool) async -> Bool {
        guard let userStateService else { return false }
        
        do {
            try await userStateService.markAsFavorite(favorite, movieId: movie.id)
            movie.setFavorite(favorite)
            return true
        } catch {
            return false
        }
        
    }
    
    func addToWatchlist(_ watchlist: Bool) async -> Bool {
        guard let userStateService else { return false }

        do {
            try await userStateService.addToWatchlist(watchlist, movieId: movie.id)
            movie.setWatchlist(watchlist)
            return true
        } catch {
            return false
        }
        
    }
    
    func rate(_ rating: Int) async -> Bool {
        guard let userStateService else { return false }

        //Store receives rating as 0 to 100, but service receives 0.5 to 10 in multiples of 0.5
        var adjustedRating:Float = Float(rating) / 10
        adjustedRating = (adjustedRating / 0.5).rounded(.down) * 0.5
        
        if adjustedRating > 10 {
            adjustedRating = 10
        }
        if adjustedRating < 0.5 {
            adjustedRating = 0.5
        }
        
        do {
            try await userStateService.rateMovie(adjustedRating, movieId: movie.id)
            movie.setUserRating(adjustedRating)
            movie.setWatchlist(false) //Server removes movie from watchlist when rating
            return true
        } catch {
            return false
        }
        
    }
    
    func deleteRate() async -> Bool {
        guard let userStateService else { return false }
        
        do {
            try await userStateService.deleteRate(movieId: movie.id)
            movie.setUserRating(nil)
            return true
        } catch {
            return false
        }
    }
    
}
