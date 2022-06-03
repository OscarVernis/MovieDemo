//
//  SessionService.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 03/05/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import Foundation

protocol SessionService {
    func requestToken() async throws -> String
    
    func validateToken(username: String, password: String, requestToken: String) async throws
    
    func createSession(requestToken: String) async throws -> String
    
    func deleteSession(sessionId: String) async throws -> Result<Void, Error>
}
