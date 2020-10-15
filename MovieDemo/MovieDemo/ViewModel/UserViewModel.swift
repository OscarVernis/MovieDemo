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
    private let service = MovieDBService()
    private var isFetching = false
    
    var didUpdate: ((Error?) -> Void)?
    
    
    var username: String? {
        return user?.username
    }
    
    var favorites: [Movie] {
        return user?.favorites ?? [Movie]()
    }
    
    var watchlist: [Movie] {
        return user?.watchlist ?? [Movie]()
    }
    
    var rated: [Movie] {
        return user?.rated ?? [Movie]()
    }
    
    var avatarURL: URL? {
        if let avatarHash = user?.avatar {
            return MovieDBService.userImageURL(forHash: avatarHash)
        }
        
        return nil
    }
    
    func updateUser() {
        if isFetching { return }
        isFetching = true
        
        guard SessionManager.shared.isLoggedIn, let sessionId = SessionManager.shared.sessionId else { return }
        isFetching = false

        service.fetchUserDetails(sessionId: sessionId) { [weak self] result in
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

    
