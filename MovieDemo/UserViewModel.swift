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
    
    func updateUser() {
        if isFetching { return }
        isFetching = true
        
        guard SessionManager.shared.isLoggedIn, let sessionId = SessionManager.shared.sessionId else { return }
        isFetching = false

        service.fetchUserDetails(sessionId: sessionId) { [weak self] user, error in
            if let user = user, error == nil {
                self?.user = user
                self?.didUpdate?(nil)
            } else {
                self?.didUpdate?(error)
            }
        }
    }
    
}

    
