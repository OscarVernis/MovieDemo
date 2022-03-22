//
//  SessionManager.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 22/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import Foundation
import KeychainAccess
import Combine

fileprivate enum LocalKeys: String {
    case loggedIn
    case username
}

class SessionManager {
    static let shared = SessionManager()
    private var service = RemoteLoginManager()
    
    var isLoggedIn: Bool = false
    var username: String?
    var sessionId: String?
    
    private var cancellables = Set<AnyCancellable>()
    
    private init() {
        load()
    }
}

//MARK:- Login
extension SessionManager {
    func login(withUsername username: String, password: String, completionHandler: @escaping (Error?) -> Void) {
        let tokenPublisher = service.requestToken()
        var token = ""
        
        let validatePubliser = tokenPublisher
            .flatMap { resultToken -> AnyPublisher<Bool, Error> in
                token = resultToken
                return self.service.validateToken(username: username, password: password, requestToken: token)
            }
                
        let sessionPubliser = validatePubliser
            .flatMap { _ in
                self.service.createSession(requestToken: token)
            }
        
        sessionPubliser.sink { completion in
            switch completion {
            case .finished:
                completionHandler(nil)
            case .failure(let error):
                completionHandler(error)
            }
        } receiveValue: { sessionId in
            self.save(username: username, sessionId: sessionId)
        }.store(in: &cancellables)
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
}

//MARK:- Logout
extension SessionManager {
    //TODO: Handle Logout service error
    func logout() {
        guard let sessionId = sessionId else { return }
        
        service.deleteSession(sessionId: sessionId)
            .sink { completion in
                switch completion {
                case .finished:
                    self.deleteUserInfo()
                case .failure(_):
                    break
                }
            } receiveValue: { _ in }
            .store(in: &cancellables)
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
