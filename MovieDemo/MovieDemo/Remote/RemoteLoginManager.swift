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
        let url = service.endpoint(forPath: "/authentication/token/new")
        let params = service.defaultParameters()
        
        return Future { promise in
            service.getString(path: "request_token", url: url, params: params, method: .get, completion: promise)
        }.eraseToAnyPublisher()
    }
    
    func validateToken(username: String, password: String, requestToken: String) -> AnyPublisher<String, Error> {
        let url = service.endpoint(forPath: "/authentication/token/validate_with_login")
        let params = service.defaultParameters()
        
        let body = [
            "username": username,
            "password": password,
            "request_token": requestToken
        ]
                
        return Future { promise in
            service.successAction(url: url, params: params, body: body, method: .post) { result in
                switch result {
                case .success():
                    promise(.success(requestToken))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
        
    }
    
    func createSession(requestToken: String) -> AnyPublisher<String, Error>  {
        let url = service.endpoint(forPath: "/authentication/session/new")
        let params = service.defaultParameters()
        
        let body = ["request_token": requestToken]
        
        return Future { promise in
            service.getString(path: "session_id", url: url, params: params, body: body, completion: promise)
        }
        .eraseToAnyPublisher()
    }
    
    func deleteSession(sessionId: String, completion: @escaping MovieDBService.SuccessActionCompletion) {
        let url = service.endpoint(forPath: "/authentication/session")
        let params = service.defaultParameters()

        let body = ["session_id": sessionId]
        
        service.successAction(url: url, params: params, body: body, method: .delete, completion: completion)
    }
}
