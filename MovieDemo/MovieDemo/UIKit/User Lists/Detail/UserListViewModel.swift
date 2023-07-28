//
//  UserListViewModel.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 27/07/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import Foundation
import Combine
 
class UserListViewModel {
    private var userList: UserList
    
    var movies: [MovieViewModel]
    
    init(userList: UserList) {
        self.userList = userList
        self.movies = userList.movies.map(MovieViewModel.init)
    }
    
    var id: Int {
        userList.id
    }
    
    var name: String {
        userList.name
    }
    
    var description: String {
        userList.description
    }
    
    var favoriteCount: Int {
        userList.favoriteCount
    }
    
    var itemCount: Int {
        userList.itemCount
    }
    
    var posterPath: String? {
        return userList.posterPath
    }
    
}

extension UserListViewModel: Identifiable, Hashable {
    static func == (lhs: UserListViewModel, rhs: UserListViewModel) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(userList.id)
    }
}
