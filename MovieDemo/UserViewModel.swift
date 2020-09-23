//
//  UserViewModel.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 22/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import Foundation

struct UserViewModel {
    var user: User
    let sessionId: String
    private let service = MovieDBService()
    
    var id: Int {
        return user.id
    }
    
    var username: String {
        return user.username
    }
}

    
