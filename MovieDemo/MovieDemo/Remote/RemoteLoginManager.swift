//
//  LoginManager.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 03/03/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import Foundation
import Combine

struct RemoteLoginManager {
    let service = MovieService()
    
    func requestToken() async throws -> String {
        try await withCheckedThrowingContinuation { continuation in
            var cancellable: AnyCancellable?
            
            let publisher: AnyPublisher<ServiceSuccessResult, Error> = service.successAction(endpoint: .RequestToken)
            cancellable = publisher
                .tryMap { guard let requestToken = $0.requestToken else { throw MovieService.ServiceError.jsonError }
                    return requestToken
                }
                .eraseToAnyPublisher()
                .sink { result in
                    switch result {
                    case .finished:
                        break
                    case let .failure(error):
                        continuation.resume(throwing: error)
                    }
                    cancellable?.cancel()
                } receiveValue: { value in
                    continuation.resume(with: .success(value) )
                }
        }
    }
    
    func validateToken(username: String, password: String, requestToken: String) async throws {
        let body = [
            "username": username,
            "password": password,
            "request_token": requestToken
        ]
        
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>)  in
            var cancellable: AnyCancellable?
            
            let publisher: AnyPublisher<ServiceSuccessResult, Error> = service.successAction(endpoint: .ValidateToken, body: body, method: .post)
            cancellable = publisher
                .sink { result in
                    switch result {
                    case .finished:
                        continuation.resume()
                    case let .failure(error):
                        continuation.resume(throwing: error)
                    }
                    cancellable?.cancel()
                } receiveValue: { _ in }
        }
    }
    
    
    func createSession(requestToken: String) async throws -> String  {
        try await withCheckedThrowingContinuation { continuation in
            var cancellable: AnyCancellable?
            let body = ["request_token": requestToken]
            
            
            let publisher: AnyPublisher<ServiceSuccessResult, Error> =  service.successAction(endpoint: .CreateSession, body: body, method: .post)
            cancellable = publisher
                .tryMap { guard let sessionId = $0.sessionId else { throw MovieService.ServiceError.jsonError }
                    return sessionId
                }
                .eraseToAnyPublisher()
                .sink { result in
                    switch result {
                    case .finished:
                        break
                    case let .failure(error):
                        continuation.resume(throwing: error)
                    }
                    cancellable?.cancel()
                } receiveValue: { value in
                    continuation.resume(with: .success(value) )
                }
        }
        
    }
    
    func deleteSession(sessionId: String) -> AnyPublisher<Bool, Error> {
        let body = ["session_id": sessionId]
        
        return service.successAction(endpoint: .DeleteSession, body: body, method: .delete)
            .compactMap { $0.success }
            .eraseToAnyPublisher()
    }
}
