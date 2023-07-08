//
//  LoginRouter.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 07/07/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import Foundation

protocol LoginRouter {
    func handle(error: UserFacingError, shouldDismiss: Bool)
    func didFinishLoginProcess()
}

extension LoginRouter {
    func handle(error: UserFacingError, shouldDismiss: Bool = false) {
        handle(error: error, shouldDismiss: shouldDismiss)
    }
    
}
