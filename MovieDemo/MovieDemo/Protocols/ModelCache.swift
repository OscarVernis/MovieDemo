//
//  ModelCache.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 08/07/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import Foundation
import Combine

protocol ModelCache<Model> {
    associatedtype Model
    
    func save(_ model: Model)
    func delete()
}

extension Publisher {
    func cache(with cache: any ModelCache<Output>) -> AnyPublisher<Output, Failure> {
        handleEvents(receiveOutput: { cache.save($0) }).eraseToAnyPublisher()
    }
    
}
