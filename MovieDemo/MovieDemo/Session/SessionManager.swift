//
//  SessionManager.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 22/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import Foundation
import KeychainAccess

fileprivate enum LocalKeys: String {
    case loggedIn
    case username
}

class SessionManager {
    enum LoginError: Error {
        case IncorrectCredentials
    }
    
    static let shared = SessionManager()
    private var service = RemoteLoginManager()
    
    var isLoggedIn: Bool = false
    var username: String?
    var sessionId: String?
        
    private init() {
        load()
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
                return .failure(error)
            }
        }
        
        save(username: username, sessionId: sessionId)
        
        return .success(())
    }
    
}

//MARK: - Save and retrieve session
extension SessionManager {
    fileprivate func load() {
        let loggedIn = UserDefaults.standard.bool(forKey: LocalKeys.loggedIn.rawValue)
        let user =  UserDefaults.standard.value(forKey: LocalKeys.username.rawValue) as? String
        
        let keychain = Keychain(service: "oscarvernis.MovieDemo")
        sessionId = keychain[user ?? ""]
        
        if sessionId != nil {
            isLoggedIn = loggedIn
            username = user
        }
    }
    
    fileprivate func save(username: String, sessionId: String) {
        self.isLoggedIn = true
        self.username = username
        self.sessionId = sessionId
        
        //Save state to user defaults
        UserDefaults.standard.setValue(username, forKey: LocalKeys.username.rawValue)
        UserDefaults.standard.setValue(true, forKey: LocalKeys.loggedIn.rawValue)
        
        //Save sessionId to keychain
        let keychain = Keychain(service: "oscarvernis.MovieDemo")
        keychain[username] = sessionId
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
            deleteUserInfo()
            return .success(())
        case .failure(let error):
            return .failure(error)
        case .none:
            return .failure(MovieService.ServiceError.NoSuccess)
        }
        
    }
    
    func deleteUserInfo() {
        //Save state to user defaults
        UserDefaults.standard.setValue(nil, forKey: LocalKeys.username.rawValue)
        UserDefaults.standard.setValue(false, forKey: LocalKeys.loggedIn.rawValue)
        
        //Save sessionId to keychain
        let keychain = Keychain(service: "oscarvernis.MovieDemo")
        keychain[username!] = nil
        
        self.isLoggedIn = false
        self.username = nil
    }
    
}
