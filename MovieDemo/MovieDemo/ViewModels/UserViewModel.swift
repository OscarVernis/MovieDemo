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
    private let service: UserLoader
    private let cache: UserCache?
    var isLoading = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init(service: UserLoader, cache: UserCache? = UserCache()) {
        self.service = service
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
                
        //Load from Cache
        loadCache()
        
        service.getUserDetails()
            .sink { [weak self] completion in
                self?.isLoading = false

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
            didUpdate?(nil)
        }
    }
    
}
