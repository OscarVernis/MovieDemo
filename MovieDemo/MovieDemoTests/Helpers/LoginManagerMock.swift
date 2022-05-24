//
//  LoginManagerMock.swift
//  MovieDemoTests
//
//  Created by Oscar Vernis on 10/05/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import Foundation
@testable import MovieDemo

class LoginManagerMock: LoginManager {
    let fails: Bool
    let error: MovieService.ServiceError?
    
    var username = ""
    var password = ""
    var loginCount = 0
    
    init(fails: Bool = false, error: MovieService.ServiceError? = .RequestError) {
        self.fails = fails
        self.error = error
    }
    
    func requestToken() async throws -> String {
        return "requestToken"
    }
    
    func validateToken(username: String, password: String, requestToken: String) async throws {
        self.username = username
        self.password = password
    }
    
    func createSession(requestToken: String) async throws -> String {
        if fails {
            if let error = error {
                throw error
            } else {
                throw MovieService.ServiceError.RequestError
            }
        }
        
        loginCount += 1
        print("login completed")
        return "sessionId"
    }
    
    func deleteSession(sessionId: String) async throws -> Result<Void, Error> {
        return fails ? .failure(MovieService.ServiceError.RequestError) : .success(())
    }
    
}
