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
    @Published var error: Error? = nil
    @Published private(set) var isLoading = false
    
    let service: UserListDetailsService
    let actionsService: UserDetailActionsService

    init(userList: UserList, service: @escaping UserListDetailsService, actionsService: UserDetailActionsService) {
        self.userList = userList
        self.service = service
        self.actionsService = actionsService
    }
    
    func movie(at index: Int) -> MovieViewModel {
        MovieViewModel(movie: userList.movies[index])
    }
    
    func addMovie(movieId: Int) async throws {
        try await actionsService.addMovie(movieId: movieId, toList: userList.id)
    }
    
    func removeMovie(at index: Int) async throws {
        let removedMovie = userList.movies.remove(at: index)
        
        do {
            try await actionsService.removeMovie(movieId: removedMovie.id, fromList: userList.id)
        } catch {
            self.error = error
            userList.movies.insert(removedMovie, at: index)
        }
    }
    
    
    func clearList() async throws {
        try await actionsService.clearList(listId: userList.id)
        userList.movies = []
    }
    
    func update() {
        isLoading = true
        
        service()
            .assignError(to: \.error, on: self)
            .onCompletion { self.isLoading = false }
            .assign(to: &$userList)
    }
}
