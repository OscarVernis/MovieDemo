//
//  LoginManager.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 03/03/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import Foundation

struct LoginManager {
    let service = MovieDBService()
    
    func requestToken(completion: @escaping MovieDBService.FetchStringCompletion) {
        let url = service.endpoint(forPath: "/authentication/token/new")
        let params = service.defaultParameters()
        
        service.fetchString(path: "request_token", url: url, params: params, method: .get, completion: completion)
    }
    
    func validateToken(username: String, password: String, requestToken: String, completion: @escaping MovieDBService.SuccessActionCompletion) {
        let url = service.endpoint(forPath: "/authentication/token/validate_with_login")
        let params = service.defaultParameters()

        let body = [
            "username": username,
            "password": password,
            "request_token": requestToken
        ]
        
        service.successAction(url: url, params: params, body: body, method: .post, completion: completion)
    }
    
    func createSession(requestToken: String, completion: @escaping MovieDBService.FetchStringCompletion) {
        let url = service.endpoint(forPath: "/authentication/session/new")
        let params = service.defaultParameters()

        let body = ["request_token": requestToken]
        
        service.fetchString(path: "session_id", url: url, params: params, body: body, completion: completion)
    }
    
    func deleteSession(sessionId: String, completion: @escaping MovieDBService.SuccessActionCompletion) {
        let url = service.endpoint(forPath: "/authentication/session")
        let params = service.defaultParameters()

        let body = ["session_id": sessionId]
        
        service.successAction(url: url, params: params, body: body, method: .delete, completion: completion)
    }
}
