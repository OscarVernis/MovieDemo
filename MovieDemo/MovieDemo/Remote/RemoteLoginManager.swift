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
        
        return service.getString(path: "request_token", url: url, params: params, method: .get)
    }
    
    func validateToken(username: String, password: String, requestToken: String) -> AnyPublisher<Void, Error> {
        let url = service.endpoint(forPath: "/authentication/token/validate_with_login")
        let params = service.defaultParameters()
        
        let body = [
            "username": username,
            "password": password,
            "request_token": requestToken
        ]
        
        return service.successAction(url: url, params: params, body: body, method: .post)
    }
    
    func createSession(requestToken: String) -> AnyPublisher<String, Error>  {
        let url = service.endpoint(forPath: "/authentication/session/new")
        let params = service.defaultParameters()
        
        let body = ["request_token": requestToken]
        
        return service.getString(path: "session_id", url: url, params: params, body: body)
    }
    
    func deleteSession(sessionId: String) -> AnyPublisher<Void, Error> {
        let url = service.endpoint(forPath: "/authentication/session")
        let params = service.defaultParameters()

        let body = ["session_id": sessionId]
        
        return service.successAction(url: url, params: params, body: body, method: .delete)
    }
}
