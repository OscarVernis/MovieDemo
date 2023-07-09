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
 
    var didUpdate: ((Error?) -> Void)?
    private var cancellables = Set<AnyCancellable>()
    
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
            .sink { [weak self] completion in
                self?.isLoading = false

                switch completion {
                case .finished:
                    self?.didUpdate?(nil)
                case .failure(let error):
                    self?.didUpdate?(error)
                }
            } receiveValue: { [weak self] user in
                self?.user = UserViewModel(user: user)
                self?.cache?.save(user: user)
            }
            .store(in: &cancellables)
    }
    
    func loadCache() {
        let user = cache?.load()
        if let user = user {
            self.user = UserViewModel(user: user)
            didUpdate?(nil)
        }
    }
    
}
