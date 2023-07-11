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
    private let service: UserService?

    private(set) var isLoading = false
    @Published var error: Error? = nil
     
    init(service: @autoclosure @escaping UserService) {
        self.service = service
    }
    
    init(service: UserService? = nil) {
        self.service = service
    }

    func updateUser() {
        guard let service, isLoading == false else { return }
        
        isLoading = true

        service()
            .assignError(to: \.error, on: self)
            .onCompletion { self.isLoading = false }
            .map(UserViewModel.init)
            .assign(to: &$user)
    }
    
}
