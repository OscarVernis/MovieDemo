//
//  UserStoreMock.swift
//  MovieDemoTests
//
//  Created by Oscar Vernis on 03/05/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import Foundation
@testable import MovieDemo

class UserStoreMock: UserStore {
    var sessionId: String?
    
    init(sessionId: String? = nil, isLoggedIn: Bool = false) {
        self.sessionId = sessionId
        
        if isLoggedIn && self.sessionId == nil {
            self.sessionId = "sessionId"
        }
    }
    
    func save(sessionId: String) {
        self.sessionId = sessionId
    }
    
    func delete() {
        self.sessionId = nil
    }
}
