//
//  SessionManager.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 22/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import Foundation
import KeychainAccess

class SessionManager {
    enum LoginError: Error {
        case Default
        case IncorrectCredentials
    }
    
    static let shared = SessionManager()
    var service: SessionService = RemoteSessionService()
    var store: UserStore = LocalUserStore()
    
    var isLoggedIn: Bool { sessionId != nil }
    var username: String? {
        return store.username
    }
    var sessionId: String? {
        return store.sessionId
    }
    
}

//MARK: - Login
extension SessionManager {
    func login(withUsername username: String, password: String) async -> Result<Void, Error> {
        var sessionId = ""
        
        do {
            let token = try await service.requestToken()
            try await service.validateToken(username: username, password: password, requestToken: token)
            sessionId = try await service.createSession(requestToken: token)
        } catch {
            if error as? MovieService.ServiceError == MovieService.ServiceError.IncorrectCredentials {
                return .failure(LoginError.IncorrectCredentials)
            } else {
                return .failure(LoginError.Default)
            }
        }
        
        store.save(username: username, sessionId: sessionId)
        
        return .success(())
    }
    
}

//MARK: - Logout
extension SessionManager {
    func logout() async -> Result<Void, Error> {
        guard let sessionId = sessionId else { return .success(()) }
        var result: Result<Void, Error>?
        
        do {
            result = try await service.deleteSession(sessionId: sessionId)
        } catch {
            return .failure(error)
        }
        
        switch result {
        case .success():
            store.delete()
            return .success(())
        case .failure(let error):
            return .failure(error)
        case .none:
            return .failure(MovieService.ServiceError.NoSuccess)
        }
        
    }
    
}
