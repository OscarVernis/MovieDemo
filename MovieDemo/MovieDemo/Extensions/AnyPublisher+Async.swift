//
//  AnyPublisher+Async.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 24/05/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import Foundation
import Combine

//Source: https://www.swiftbysundell.com/articles/connecting-async-await-with-other-swift-code/
extension Publishers {
    struct MissingOutputError: Error {}
}

extension Publisher {
    func completion(handler: @escaping ((Result<Output, Error>) -> Void)) {
        var cancellable: AnyCancellable?
        var didReceiveValue = false
                
        cancellable = sink(
            receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    handler(.failure(error))
                case .finished:
                    if !didReceiveValue {
                        handler(.failure(Publishers.MissingOutputError()))
                    }
                }
            },
            receiveValue: { value in
                guard !didReceiveValue else { return }
                
                didReceiveValue = true
                cancellable?.cancel()
                handler(.success(value))
            }
        )
    }
    
    func async() async throws -> Output {
        var cancellable: AnyCancellable?
        var didReceiveValue = false
        
        return try await withCheckedThrowingContinuation { continuation in
            cancellable = sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    case .finished:
                        if !didReceiveValue {
                            continuation.resume(
                                throwing: Publishers.MissingOutputError()
                            )
                        }
                    }
                },
                receiveValue: { value in
                    guard !didReceiveValue else { return }
                    
                    didReceiveValue = true
                    cancellable?.cancel()
                    continuation.resume(returning: value)
                }
            )
        }
    }
}
