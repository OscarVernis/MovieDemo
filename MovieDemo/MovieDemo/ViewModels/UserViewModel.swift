//
//  UserViewModel.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 22/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import Foundation
import Combine

class UserViewModel {
    var user: User?
    private let sessionManager: SessionManager
    private let service: UserLoader
    private let cache: UserCache?
    private var isLoading = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init(sessionManager: SessionManager = SessionManager.shared,
         cache: UserCache? = UserCache()) {
        self.sessionManager = sessionManager
        self.service = RemoteUserLoader(sessionId: sessionManager.sessionId)
        self.cache = cache
    }
    
    var didUpdate: ((Error?) -> Void)?
    
    var username: String? {
        return user?.username
    }
    
    var favorites: [MovieViewModel] {
        return user?.favorites.map { MovieViewModel(movie: $0) } ?? [MovieViewModel]()
    }
    
    var watchlist: [MovieViewModel] {
        return user?.watchlist.map { MovieViewModel(movie: $0) } ?? [MovieViewModel]()
    }
    
    var rated: [MovieViewModel] {
        return user?.rated.map { MovieViewModel(movie: $0) } ?? [MovieViewModel]()
    }
    
    var avatarURL: URL? {
        if let avatarHash = user?.avatar {
            return MovieService.userImageURL(forHash: avatarHash)
        }
        
        return nil
    }
    
    func updateUser() {
        if isLoading { return }
        isLoading = true
        
        guard sessionManager.isLoggedIn else { return }
        isLoading = false
        
        //Load from Cache
        loadCache()
        
        service.getUserDetails()
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    self?.didUpdate?(nil)
                case .failure(let error):
                    self?.didUpdate?(error)
                }
            } receiveValue: { [weak self] user in
                self?.user = user
                self?.cache?.save(user: user)
            }
            .store(in: &cancellables)
    }
    
    func loadCache() {
        let user = cache?.load()
        if let user = user {
            self.user = user
            self.didUpdate?(nil)
        }
    }
}

