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
    static var shared = SessionManager()
    private var service = MovieDBService()
    
    var isLoggedIn: Bool = false
    var username: String?
    var sessionId: String?
    
    
    
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
        
        //Save state to user defaults
        UserDefaults.standard.setValue(username, forKey: LocalKeys.username.rawValue)
        UserDefaults.standard.setValue(true, forKey: LocalKeys.loggedIn.rawValue)
        
        //Save sessionId to keychain
        let keychain = Keychain(service: "oscarvernis.MovieDemo")
        keychain[username] = sessionId
    }
}

//MARK:- Session creation
extension SessionManager {
    func login(withUsername username: String, password: String, completion: @escaping (String?, Error?) -> Void) {
        service.requestToken { [weak self] requestToken , error in
            if error == nil {
                self?.validateToken(requestToken!, username: username, password: password, completion: completion)
            } else {
                completion(nil, error)
            }
        }
    }
    
    fileprivate func validateToken(_ token: String, username: String, password: String, completion: @escaping (String?, Error?) -> Void)  {
        service.validateToken(username: username, password: password, requestToken: token) { [weak self] success, error in
            if success && error == nil {
                self?.createSession(token: token, username: username, completion: completion)
            } else {
                completion(nil, error)
            }
        }
    }
    
    fileprivate func createSession(token: String, username: String, completion: @escaping (String?, Error?) -> Void) {
        service.createSession(requestToken: token) { [weak self] (sessionId, error) in
            if error == nil {
                self?.save(username: username, sessionId: sessionId!)
                completion(sessionId, nil)
            } else {
                completion(nil, error)
             }
        }
    }
    
}
