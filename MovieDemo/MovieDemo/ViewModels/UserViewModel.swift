//
//  UserViewModel.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 22/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import Foundation

class UserViewModel {
    var user: User?
    private let service = RemoteUserManager()
    private var isLoading = false
    
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
            return MovieDBService.userImageURL(forHash: avatarHash)
        }
        
        return nil
    }
    
    func updateUser() {
        if isLoading { return }
        isLoading = true
        
        guard SessionManager.shared.isLoggedIn, let sessionId = SessionManager.shared.sessionId else { return }
        isLoading = false

        service.getUserDetails(sessionId: sessionId) { [weak self] result in
            switch result {
            case .success(let user):
                self?.user = user
                self?.didUpdate?(nil)
            case .failure(let error):
                self?.didUpdate?(error)
                
            }
        }
    }
    
}

    
