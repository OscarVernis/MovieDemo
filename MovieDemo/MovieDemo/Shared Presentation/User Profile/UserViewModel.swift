//
//  UserViewModel.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 22/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import Foundation
import Combine

class UserViewModel: ObservableObject {
    @Published private(set) var user: User
    
    init() {
        self.user = User()
    }
    
    init(user: User) {
        self.user = user
    }
        
    var username: String {
        return user.username ?? ""
    }
    
    var favorites: [MovieViewModel] {
        return user.favorites.map { MovieViewModel(movie: $0) }
    }
    
    var watchlist: [MovieViewModel] {
        return user.watchlist.map { MovieViewModel(movie: $0) }
    }
    
    var rated: [MovieViewModel] {
        return user.rated.map { MovieViewModel(movie: $0) }
    }
    
    var avatarURL: URL? {
        if let avatarHash = user.avatar {
            return MovieServiceImageUtils.userImageURL(forHash: avatarHash)
        }
        
        return nil
    }
    
}
