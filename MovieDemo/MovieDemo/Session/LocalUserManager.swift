//
//  LocalUserManager.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 03/05/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import Foundation
import KeychainAccess

class LocalUserManager: UserManager {
    fileprivate enum LocalKeys: String {
        case loggedIn
        case username
    }
    
    var sessionId: String?
    var username: String?
    var isLoggedIn: Bool = false
    
    init() {
        load()
    }
    
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
    
    func save(username: String, sessionId: String) {
        //Save state to user defaults
        UserDefaults.standard.setValue(username, forKey: LocalKeys.username.rawValue)
        UserDefaults.standard.setValue(true, forKey: LocalKeys.loggedIn.rawValue)
        
        //Save sessionId to keychain
        let keychain = Keychain(service: "oscarvernis.MovieDemo")
        keychain[username] = sessionId
    }
    
    func delete() {
        //Delte state from user defaults
        UserDefaults.standard.setValue(nil, forKey: LocalKeys.username.rawValue)
        UserDefaults.standard.setValue(false, forKey: LocalKeys.loggedIn.rawValue)
        
        //Delete sessionId from keychain
        let keychain = Keychain(service: "oscarvernis.MovieDemo")
        keychain[username!] = nil
        
        self.isLoggedIn = false
        self.username = nil
    }
}
