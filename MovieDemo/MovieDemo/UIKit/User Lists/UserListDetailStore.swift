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
    
    func update() {
        isLoading = true
        
        service()
            .assignError(to: \.error, on: self)
            .onCompletion { self.isLoading = false }
            .assign(to: &$userList)
    }
}
