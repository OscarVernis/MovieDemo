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
    var store: SessionStore = KeychainSessionStore()
    
    var isLoggedIn: Bool { sessionId != nil }

    var sessionId: String? {
        return store.sessionId
    }
    
}

//MARK: - Login
extension SessionManager {
    func save(sessionId: String) {
        store.save(sessionId: sessionId)
    }
    
    func login(withUsername username: String, password: String) async -> Result<Void, Error> {
        var sessionId = ""
        
        do {
            let token = try await service.requestToken()
            try await service.validateToken(username: username, password: password, requestToken: token)
            sessionId = try await service.createSession(requestToken: token)
        } catch {
            if error as? TMDBClient.ServiceError == .IncorrectCredentials {
                return .failure(LoginError.IncorrectCredentials)
            } else {
                return .failure(LoginError.Default)
            }
        }
        
        save(sessionId: sessionId)
        
        return .success(())
    }
    
}

//MARK: - Logout
extension SessionManager {
    func logout() async -> Result<Void, UserFacingError> {
        guard let sessionId = sessionId else { return .success(()) }
        var result: Result<Void, Error>?
                
        do {
            result = try await service.deleteSession(sessionId: sessionId)
        } catch {
            return .failure(.logoutError)
        }
        
        switch result {
        case .success():
            store.delete()
            return .success(())
        case .failure(_), .none:
            return .failure(.logoutError)
        }
    }
    
}
