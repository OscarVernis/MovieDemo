//
//  UserManagerMock.swift
//  MovieDemoTests
//
//  Created by Oscar Vernis on 03/05/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import Foundation
@testable import MovieDemo

class UserManagerMock: UserManager {
    var sessionId: String?
    var username: String?
    var isLoggedIn: Bool
    
    init(sessionId: String? = nil, username: String? = nil, isLoggedIn: Bool) {
        self.sessionId = sessionId
        self.username = username
        self.isLoggedIn = isLoggedIn
    }
    
    func save(username: String, sessionId: String) {
        self.sessionId = sessionId
        self.username = username
        self.isLoggedIn = true
    }
    
    func delete() {
        self.sessionId = nil
        self.username = nil
        self.isLoggedIn = false
    }
}
