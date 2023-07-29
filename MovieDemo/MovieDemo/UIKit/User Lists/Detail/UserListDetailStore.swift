//
//  UserListDetailStore.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 26/07/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import Foundation

class UserListDetailStore {
    @Published var userList: UserList
    @Published var movies: [MovieViewModel] {
        didSet {
            updateRating()
        }
    }
    @Published var error: Error? = nil
    @Published private(set) var isLoading = false
    
    let service: UserListDetailsService
    let actionsService: UserDetailActionsService

    init(userList: UserList, service: @escaping UserListDetailsService, actionsService: UserDetailActionsService) {
        self.userList = userList
        self.movies = userList.movies.map(MovieViewModel.init)
        self.service = service
        self.actionsService = actionsService
    }
    
    func movie(at index: Int) -> MovieViewModel {
        movies[index]
    }
    
    func add(movie: MovieViewModel) async throws {
        try await actionsService.addMovie(movieId: movie.id, toList: userList.id)
        movies.append(movie)
    }
    
    func removeMovie(at index: Int) async throws {
        let removedMovie = movies.remove(at: index)
        
        do {
            try await actionsService.removeMovie(movieId: removedMovie.id, fromList: userList.id)
        } catch {
            self.error = error
            movies.insert(removedMovie, at: index)
        }
    }
    
    
    func clearList() async throws {
        try await actionsService.clearList(listId: userList.id)
        movies.removeAll()
    }
    
    func update() {
        isLoading = true
        
        service()
            .assignError(to: \.error, on: self)
            .onCompletion { self.isLoading = false }
            .handleEvents(receiveOutput: { userList in
                self.movies = userList.movies.map(MovieViewModel.init)
            })
            .assign(to: &$userList)
    }
    
    //MARK: - Data Formatting
    var ratingString: String = MovieString.NR.localized
    var percentRating = 0
    
    func updateRating() {
        let ratings = movies.filter(\.isRatingAvailable).map(\.percentRating)
        let total = ratings.reduce(0, +)
        
        if total == 0 {
            percentRating = 0
            ratingString = MovieString.NR.localized
        } else {
            percentRating = Int(total) / ratings.count
            ratingString = "\(percentRating)"
        }
    }
    
}
