//
//  UserProfileStore.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 08/07/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import Foundation
import Combine

class UserProfileStore: ObservableObject {
    @Published private(set) var user: UserViewModel = UserViewModel()
    private let service: UserLoader?
    private let cache: UserCache?

    private(set) var isLoading = false
    @Published var error: Error? = nil
     
    internal init(service: UserLoader? = nil, cache: UserCache? = nil) {
        self.service = service
        self.cache = cache
    }

    func updateUser() {
        guard let service, isLoading == false else { return }
        
        isLoading = true
                
        //Load from Cache
        loadCache()
        
        service.getUserDetails()
            .assignError(to: \.error, on: self)
            .handleEvents(receiveOutput: { [weak self] user in
                self?.isLoading = false
                self?.cache?.save(user: user)
            })
            .map(UserViewModel.init)
            .assign(to: &$user)
    }
    
    func loadCache() {
        let user = cache?.load()
        if let user {
            self.user = UserViewModel(user: user)
        }
    }
    
}
