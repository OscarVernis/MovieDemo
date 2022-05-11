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
        case username
    }
    
    var sessionId: String?
    var username: String?
    
    init() {
        load()
    }
    
    fileprivate func load() {
        let user =  UserDefaults.standard.value(forKey: LocalKeys.username.rawValue) as? String
        
        let keychain = Keychain(service: "oscarvernis.MovieDemo")
        self.sessionId = keychain[user ?? ""]
        
        if sessionId != nil {
            username = user
        }
    }
    
    func save(username: String, sessionId: String) {
        self.username = username
        self.sessionId = sessionId
        
        //Save state to user defaults
        UserDefaults.standard.setValue(username, forKey: LocalKeys.username.rawValue)
        
        //Save sessionId to keychain
        let keychain = Keychain(service: "oscarvernis.MovieDemo")
        keychain[username] = sessionId
    }
    
    func delete() {
        //Delete state from user defaults
        UserDefaults.standard.setValue(nil, forKey: LocalKeys.username.rawValue)
        
        //Delete sessionId from keychain
        let keychain = Keychain(service: "oscarvernis.MovieDemo")
        keychain[username!] = nil
        
        self.username = nil
        self.sessionId = nil
    }
    
}
