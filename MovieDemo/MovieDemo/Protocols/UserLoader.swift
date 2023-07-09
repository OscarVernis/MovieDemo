//
//  UserLoader.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 06/06/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import Foundation
import Combine

protocol UserLoader {
    func getUserDetails() -> AnyPublisher<User, Error>
}

typealias UserCacheLoader = ModelCache<User> & UserLoader

struct UserLoaderWithCache: UserLoader {
    let main: UserLoader
    let cache: any UserCacheLoader
    
    func getUserDetails() -> AnyPublisher<User, Error> {
        return main.getUserDetails()
            .merge(with: cache.getUserDetails())
            .handleEvents(receiveOutput:  { user in
                cache.save(user)
            })
            .eraseToAnyPublisher()
    }
}
