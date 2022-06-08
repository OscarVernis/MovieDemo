//
//  MovieUserStatesViewModel.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 17/05/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import Foundation
import Combine

class MovieUserStatesViewModel {
    private unowned var movie: MovieViewModel
    
    private let service: RemoteUserState!

    private var cancellables = Set<AnyCancellable>()

    init(movie: MovieViewModel, sessionId: String?) {
        self.service = RemoteUserState(sessionId: sessionId)
        self.movie = movie
    }
    
}

//MARK: - User States
extension MovieUserStatesViewModel {
    var userRating: UInt {
        return UInt(movie.userRating ?? 0)
    }

    var percentUserRating: UInt {
        return UInt((movie.userRating ?? 0) * 10)
    }
    
    var userRatingString: String {
        return movie.userRating != nil ? "\(percentUserRating)" : .localized(MovieString.NR)
    }
    
    func markAsFavorite(_ favorite: Bool, completionHandler: @escaping (Bool) -> Void) {
        service.markAsFavorite(favorite, movieId: movie.id)
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
        service.addToWatchlist(watchlist, movieId: movie.id)
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
        //ViewModel receives rating as 0 to 100, but service receives 0.5 to 10 in multiples of 0.5
        var adjustedRating:Float = Float(rating) / 10
        adjustedRating = (adjustedRating / 0.5).rounded(.down) * 0.5
        
        if adjustedRating > 10 {
            adjustedRating = 10
        }
        if adjustedRating < 0.5 {
            adjustedRating = 0.5
        }
        
        service.rateMovie(adjustedRating, movieId: movie.id)
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
        service.deleteRate(movieId: movie.id)
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
