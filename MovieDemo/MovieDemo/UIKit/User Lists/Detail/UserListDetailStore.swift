//
//  UserListDetailStore.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 26/07/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import Foundation

class UserListDetailStore {
    @Published var userList: UserListViewModel
    @Published var movies: [MovieViewModel]
    @Published var error: Error? = nil
    @Published private(set) var isLoading = false
    
    let service: UserListDetailsService
    let actionsService: UserDetailActionsService

    init(userList: UserListViewModel, service: @escaping UserListDetailsService, actionsService: UserDetailActionsService) {
        self.userList = userList
        self.service = service
        self.actionsService = actionsService
        self.movies = userList.movies
    }
    
    func movie(at index: Int) -> MovieViewModel {
        movies[index]
    }
    
    func add(movie: MovieViewModel) async throws {
        try await actionsService.addMovie(movieId: movie.id, toList: userList.id)
        movies.insert(movie, at: 0)
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
            .map { [unowned self] userList in
                let vm = UserListViewModel(userList: userList)
                self.movies = vm.movies
                return vm
            }
            .assign(to: &$userList)
    }
    
}
