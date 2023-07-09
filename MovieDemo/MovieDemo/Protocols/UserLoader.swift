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

extension UserLoader {
    func with(cache: UserCache) -> UserLoader {
        UserLoaderWithCache(main: self, cache: cache)
    }
}

typealias UserCacheLoader = ModelCache<User> & UserLoader

struct UserLoaderWithCache: UserLoader {
    let main: UserLoader
    let cache: any UserCacheLoader

    func getUserDetails() -> AnyPublisher<User, Error> {
        return main.getUserDetails()
            .handleEvents(receiveOutput: { user in
                cache.save(user)
            })
            .merge(with: cache.getUserDetails()
                .catch { _ in
                    Empty(completeImmediately: true)
                }
            )
            .eraseToAnyPublisher()
    }
}
