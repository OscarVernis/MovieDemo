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
    
    func load() throws -> Model
    func save(_ model: Model)
    func delete()
    
    var publisher: AnyPublisher<Model, Error> { get }
}

extension ModelCache {
    var publisher: AnyPublisher<Model, Error> {
        let model = try? load()
        if let model {
            return Just(model)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } else {
            return Empty(completeImmediately: true)
                .eraseToAnyPublisher()
        }
    }
    
}

extension Publisher {
    func cache(with cache: any ModelCache<Output>) -> AnyPublisher<Output, Failure> {
        handleEvents(receiveOutput: { cache.save($0) }).eraseToAnyPublisher()
    }
    
}
