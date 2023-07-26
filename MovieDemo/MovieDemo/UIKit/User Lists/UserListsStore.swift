//
//  UserListsStore.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 26/07/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import Foundation
import Combine

class UserListsStore {
    @Published var lists: [UserList] = []
    @Published var error: Error? = nil
    
    let service: UserListsService
    private(set) var isLoading = false
    
    init(service: @escaping UserListsService) {
        self.service = service
    }
    
    func update() {
        service(1)
            .assignError(to: \.error, on: self)
            .map(\.lists)
            .assign(to: &$lists)
    }
}
