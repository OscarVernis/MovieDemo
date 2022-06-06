//
//  LocalUserManager.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 03/05/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import Foundation
import KeychainAccess

class LocalUserStore: UserStore {
    let keychainKey = "oscarvernis.MovieDemo"
    let sessionKey = "session-id"
    
    var sessionId: String?
    
    init() {
        load()
    }
    
    fileprivate func load() {
        let keychain = Keychain(service: keychainKey)
        self.sessionId = keychain[sessionKey]
    }
    
    func save(sessionId: String) {
        self.sessionId = sessionId
        
        //Save sessionId to keychain
        let keychain = Keychain(service: keychainKey)
        keychain[sessionKey] = sessionId
    }
    
    func delete() {
        //Delete sessionId from keychain
        let keychain = Keychain(service: keychainKey)
        keychain[sessionKey] = nil
        
        self.sessionId = nil
    }
    
}
