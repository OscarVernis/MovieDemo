//
//  ErrorHandlingRouter.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 08/07/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import UIKit

protocol ErrorHandlingRouter {
    func handle(error: UserFacingError, shouldDismiss: UIViewController?)
}

extension ErrorHandlingRouter {
    func handle(error: UserFacingError, shouldDismiss viewController: UIViewController? = nil) {
        handle(error: error, shouldDismiss: viewController)
    }
}
