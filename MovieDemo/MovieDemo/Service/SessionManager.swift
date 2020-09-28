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
    static let shared = SessionManager()
    private var service = MovieDBService()
    
    var isLoggedIn: Bool = false
    var username: String?
    var sessionId: String?
    
    private var loginCompletionHandler: ((Error?) -> Void)? = nil
    
    init() {
        load()
    }
}

//MARK:- Save and retrieve session
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
    
    func logout() {
        if let sessionId = sessionId {
            service.deleteSession(sessionId: sessionId) { success, error in
            }
        }
                
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

//MARK:- Session creation
extension SessionManager {
    func login(withUsername username: String, password: String, completion: @escaping (Error?) -> Void) {
        service.requestToken { [weak self] requestToken, error in
            if error == nil {
                self?.loginCompletionHandler = completion
                self?.validateToken(requestToken!, username: username, password: password)
            } else {
                self?.loginCompletionHandler?(error)
            }
        }
    }
    
    fileprivate func validateToken(_ token: String, username: String, password: String)  {
        service.validateToken(username: username, password: password, requestToken: token) { [weak self] success, error in
            if success && error == nil {
                self?.createSession(token: token, username: username)
            } else {
                self?.loginCompletionHandler?(error)
            }
        }
    }
    
    fileprivate func createSession(token: String, username: String) {
        service.createSession(requestToken: token) { [weak self] (sessionId, error) in
            if error == nil {
                self?.save(username: username, sessionId: sessionId!)
                self?.loginCompletionHandler?(nil)
            } else {
                self?.loginCompletionHandler?(error)
             }
        }
    }
    
}
