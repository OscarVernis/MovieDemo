//
//  LoginViewModel.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 17/05/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import Foundation
import Combine

class LoginViewStore {
    @Published var loggedIn: Bool = false
    @Published var errorString: String? = nil
    @Published var isLoading: Bool = false
    @Published var validInput: Bool = false
    
    var loginService: LoginService
    
    init(loginService: LoginService) {
        self.loginService = loginService
    }
    
    func validateInput(username: String?, password: String?) {
        validInput = !(username?.isEmpty ?? true || password?.isEmpty ?? true)
    }
    
    @MainActor
    func login(username: String, password: String) {
        isLoading = true
        
        Task {
            let result = await loginService.login(withUsername: username, password: password)
            
            isLoading = false
            
            switch result {
            case .success():
                loggedIn = true
            case .failure(let error):
                if error as? LoginError == .IncorrectCredentials {
                    errorString = .localized(ErrorString.LoginCredentialsError)
                } else {
                    errorString = .localized(ErrorString.LoginError)
                }
            }
        }
    }
    
    func resetError() {
        errorString = nil
    }
    
}
