//
//  MovieDetailStore.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 07/07/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import Foundation
import Combine

class MovieDetailStore {
    var movie: MovieViewModel
    private var movieService: MovieDetailsLoader?
    private let userStateService: RemoteUserState?
    
    private var cancellables = Set<AnyCancellable>()
    
    init(movie: MovieViewModel, movieService: MovieDetailsLoader? = RemoteMovieDetailsLoader(), userStateService: RemoteUserState? = nil) {
        self.movie = movie
        self.movieService = movieService
        self.userStateService = userStateService
    }

    //MARK: - Get Movie Details
    private(set) var isLoading = false
    var didUpdate: ((Error?) -> Void)?
    
    func refresh() {
        getMovieDetails()
    }
    
    private func getMovieDetails() {
        guard let movieService else { return }

        isLoading = true
                
        movieService.getMovieDetails(movieId: movie.id)
            .sink { [weak self] completion in
                self?.isLoading = false
                
                switch completion {
                case .finished:
                    self?.didUpdate?(nil)
                case .failure(let error):
                    self?.didUpdate?(error)
                }
            } receiveValue: { [weak self] movie in
                self?.movie = MovieViewModel(movie: movie)
            }
            .store(in: &cancellables)
    }
    
    //MARK: - User Actions
    var hasUserStates: Bool {
        return userStateService != nil
    }
    
    func markAsFavorite(_ favorite: Bool, completionHandler: @escaping (Bool) -> Void) {
        guard let userStateService else { return }
        
        userStateService.markAsFavorite(favorite, movieId: movie.id)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    self?.movie.setFavorite(favorite)
                    completionHandler(true)
                case .failure(_):
                    completionHandler(false)
                }
            } receiveValue: { _ in }
            .store(in: &cancellables)
        
    }
    
    func addToWatchlist(_ watchlist: Bool, completionHandler: @escaping (Bool) -> Void) {
        guard let userStateService else { return }

        userStateService.addToWatchlist(watchlist, movieId: movie.id)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    self?.movie.setWatchlist(watchlist)
                    completionHandler(true)
                case .failure(_):
                    completionHandler(false)
                }
            } receiveValue: { _ in }
            .store(in: &cancellables)
    }
    
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
        
        userStateService.rateMovie(adjustedRating, movieId: movie.id)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    self?.movie.setUserRating(adjustedRating)
                    self?.movie.setWatchlist(false) //Server removes movie from watchlist when rating
                    completionHandler(true)
                case .failure(_):
                    completionHandler(false)

                }
            } receiveValue: { _ in }
            .store(in: &cancellables)
        
    }
    
    func deleteRate(completionHandler: @escaping (Bool) -> Void) {
        guard let userStateService else { return }

        userStateService.deleteRate(movieId: movie.id)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    self?.movie.setUserRating(nil)
                    completionHandler(true)
                case .failure(_):
                    completionHandler(false)

                }
            } receiveValue: { _ in }
            .store(in: &cancellables)
    }
}
