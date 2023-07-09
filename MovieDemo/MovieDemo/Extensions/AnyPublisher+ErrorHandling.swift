//
//  AnyPublisher+ErrorHandling.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 08/07/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import Foundation
import Combine

extension Publisher {
    /// Removes the error from the publisher and assigns it to a property on an object.
    func assignError<Root>(to keyPath: ReferenceWritableKeyPath<Root, Self.Failure?>, on object: Root) -> AnyPublisher<Output, Never> {
        self.catch { error in
                object[keyPath: keyPath] = error
                
                return Empty<Output, Never>(completeImmediately: true)
            }
            .eraseToAnyPublisher()
    }

    /// Removes the error from the publisher and sends it to the provided handler.
    func handleError(_ handler: @escaping (Error) -> Void) -> AnyPublisher<Output, Never> {
        self.catch { error in
                handler(error)
                
                return Empty<Output, Never>(completeImmediately: true)
            }
            .eraseToAnyPublisher()
        
    }
    
    func onCompletion(handler: @escaping () -> Void) -> AnyPublisher<Output, Failure> {
        handleEvents(receiveCompletion:  { _ in
            handler()
        })
        .eraseToAnyPublisher()
    }
    
}
