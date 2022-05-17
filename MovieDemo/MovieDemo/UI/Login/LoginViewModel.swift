//
//  LoginViewModel.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 17/05/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import Foundation
import Combine

class LoginViewModel {
    @Published var loggedIn: Bool = false
    @Published var errorString: String? = nil
    @Published var isLoading: Bool = false
    @Published var validInput: Bool = false
    
    let sessionManager = SessionManager.shared
    
    func validateInput(username: String?, password: String?) {
        validInput = !(username?.isEmpty ?? true || password?.isEmpty ?? true)
    }
    
    @MainActor
    func login(username: String, password: String) {
        isLoading = true
        
        Task {
            let result = await sessionManager.login(withUsername: username, password: password)
            
            isLoading = false
            
            switch result {
            case .success():
                loggedIn = true
            case .failure(let error):
                if error as? SessionManager.LoginError == SessionManager.LoginError.IncorrectCredentials {
                    errorString = .localized(.LoginCredentialsError)
                } else {
                    errorString = .localized(.LoginError)
                }
            }
        }
    }
    
    func resetError() {
        errorString = nil
    }
    

}
