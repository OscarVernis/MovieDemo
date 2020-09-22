//
//  AlertManager.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 20/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit
import Loaf

struct AlertManager {
    static func showErrorAlert(_ title: String, sender: UIViewController) {
        Loaf(title, state: .error, location: .bottom, presentingDirection: .vertical, dismissingDirection: .vertical, sender: sender).show()
    }
    
    static func showLoginErrorAlert(sender: UIViewController) {
        Loaf("Login Error", state: .error, location: .top, presentingDirection: .vertical, dismissingDirection: .vertical, sender: sender).show()
    }
    
    static func showNetworkConnectionAlert(sender: UIViewController) {
        Loaf("Check your network connection.", state: .error, location: .bottom, presentingDirection: .vertical, dismissingDirection: .vertical, sender: sender).show()
    }
    
    static func showRefreshErrorAlert(text: String = "Couldn't refresh content.", sender: UIViewController, completion: (() -> Void)? = nil) {
        Loaf(text, state: .error, location: .bottom, presentingDirection: .vertical, dismissingDirection: .vertical, sender: sender).show { _ in
            completion?()
        }
    }
    
}
