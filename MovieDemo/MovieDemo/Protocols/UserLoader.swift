//
//  UserLoader.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 06/06/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import Foundation
import Combine

typealias UserService = () -> AnyPublisher<User, Error>

extension Publisher {
    func cache(with cache: any ModelCache<Output>) -> AnyPublisher<Output, Failure> {
        handleEvents(receiveOutput: { cache.save($0) }).eraseToAnyPublisher()
    }
    
    func placeholder(with placeholder: AnyPublisher<Output, Failure>) -> AnyPublisher<Output, Failure> {
        placeholder
            .merge(with: self)
            .eraseToAnyPublisher()
    }
    
}
