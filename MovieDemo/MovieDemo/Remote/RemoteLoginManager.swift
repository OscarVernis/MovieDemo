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
    let service = MovieDBService()
    
    func requestToken() -> AnyPublisher<String, Error> {
        return service.successAction(path: "/authentication/token/new")
            .tryMap { guard let requestToken = $0.requestToken else { throw MovieDBService.ServiceError.jsonError }
                return requestToken
            }
            .eraseToAnyPublisher()
    }
    
    func validateToken(username: String, password: String, requestToken: String) -> AnyPublisher<Bool, Error> {
        let body = [
            "username": username,
            "password": password,
            "request_token": requestToken
        ]
        
        return service.successAction(path: "/authentication/token/validate_with_login", body: body, method: .post)
            .compactMap { $0.success }
            .eraseToAnyPublisher()
    }
    
    func createSession(requestToken: String) -> AnyPublisher<String, Error>  {
        let body = ["request_token": requestToken]
        
        return service.successAction(path: "/authentication/session/new", body: body, method: .post)
            .tryMap { guard let sessionId =  $0.sessionId else { throw MovieDBService.ServiceError.jsonError }
                return sessionId
            }
            .eraseToAnyPublisher()
    }
    
    func deleteSession(sessionId: String) -> AnyPublisher<Bool, Error> {
        let body = ["session_id": sessionId]
        
        return service.successAction(path: "/authentication/session", body: body, method: .delete)
            .compactMap { $0.success }
            .eraseToAnyPublisher()
    }
}
