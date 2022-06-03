//
//  RemoteSessionService.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 03/03/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import Foundation
import Combine

struct RemoteSessionService: SessionService {
    let service = MovieService()
}

//MARK: - Login
extension RemoteSessionService {
    func requestToken() async throws -> String {
        let serviceResult: ServiceSuccessResult = try await service.successAction(endpoint: .requestToken).async()
        guard let token: String = serviceResult.requestToken else { throw MovieService.ServiceError.JsonError }
        
        return token
    }
    
    func validateToken(username: String, password: String, requestToken: String) async throws {
        let body = [
            "username": username,
            "password": password,
            "request_token": requestToken
        ]
        
        let _: ServiceSuccessResult = try await service.successAction(endpoint: .validateToken, body: body, method: .post).async()
    }
    
    
    func createSession(requestToken: String) async throws -> String  {
        let body = ["request_token": requestToken]
        let serviceResult: ServiceSuccessResult = try await service.successAction(endpoint: .createSession, body: body, method: .post).async()
        
        guard let sessionId: String = serviceResult.sessionId else { throw MovieService.ServiceError.JsonError }
        
        return sessionId
    }
    
}

//MARK: - Logout
extension RemoteSessionService {
    func deleteSession(sessionId: String) async throws -> Result<Void, Error> {
        let body = ["session_id": sessionId]
        
        let result = try await service.successAction(endpoint: .deleteSession, body: body, method: .delete).async()
        if let success = result.success, success == true {
            return .success(())
        } else {
            return .failure(MovieService.ServiceError.NoSuccess)
        }
    }

}
