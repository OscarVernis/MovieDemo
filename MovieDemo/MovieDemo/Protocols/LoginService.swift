//
//  LoginService.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 22/07/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import Foundation

enum LoginError: Error {
    case Default
    case IncorrectCredentials
}

protocol LoginService {
    func login(withUsername username: String, password: String) async -> Result<Void, Error>
}

protocol WebLoginService {
    func requestToken() async throws -> String
    func login(withRequestToken: String) async throws
}
