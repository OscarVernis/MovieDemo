//
//  ErrorHandlingRouter.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 08/07/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import Foundation

protocol ErrorHandlingRouter {
    func handle(error: UserFacingError, shouldDismiss: Bool)
}

extension ErrorHandlingRouter {
    func handle(error: UserFacingError, shouldDismiss: Bool = false) {
        handle(error: error, shouldDismiss: shouldDismiss)
    }
}
