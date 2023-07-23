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
    var service: SessionService
    var store: SessionStore
    
    var isLoggedIn: Bool { sessionId != nil }

    var sessionId: String? {
        return store.sessionId
    }
    
    init(service: SessionService, store: SessionStore) {
        self.service = service
        self.store = store
    }
}

//MARK: - Login
extension SessionManager: LoginService {
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

//MARK: - Web Login
extension SessionManager: WebLoginService {
    func requestToken() async throws -> String {
        do {
            return try await service.requestToken()
        } catch {
            throw LoginError.Default
        }
    }
    
    func login(withRequestToken token: String) async throws {
        do {
            let sessionId = try await service.createSession(requestToken: token)
            save(sessionId: sessionId)
        } catch {
            throw LoginError.Default
        }
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
