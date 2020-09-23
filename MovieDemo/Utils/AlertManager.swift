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
        Loaf(title, state: .error, location: .bottom, presentingDirection: .vertical, dismissingDirection: .vertical, sender: sender).show(.short)
    }
    
    static func showLoginErrorAlert(sender: UIViewController) {
        Loaf("Login Error", state: .error, location: .top, presentingDirection: .vertical, dismissingDirection: .vertical, sender: sender).show(.short)
    }
    
    static func showNetworkConnectionAlert(sender: UIViewController) {
        Loaf("Check your network connection.", state: .error, location: .bottom, presentingDirection: .vertical, dismissingDirection: .vertical, sender: sender).show(.short)
    }
    
    static func showRefreshErrorAlert(text: String = "Couldn't refresh content.", sender: UIViewController, completion: (() -> Void)? = nil) {
        Loaf(text, state: .error, location: .bottom, presentingDirection: .vertical, dismissingDirection: .vertical, sender: sender).show(.short) { _ in
            completion?()
        }
    }
    
    static func showFavoriteAlert(text: String, sender: UIViewController, completion: (() -> Void)? = nil) {
        Loaf(text, state: .custom(.init(backgroundColor: .systemPink, icon: UIImage(systemName: "heart.fill"), textAlignment: .center, width: .screenPercentage(0.7))), location: .bottom,  sender: sender).show(.short)
    }
    
    static func showWatchlistAlert(text: String, sender: UIViewController, completion: (() -> Void)? = nil) {
        Loaf(text, state: .custom(.init(backgroundColor: .systemYellow, icon: UIImage(systemName: "bookmark.fill"), textAlignment: .center, width: .screenPercentage(0.7))), location: .bottom,  sender: sender).show(.short)
    }
    
    
    static func showRatingAlert(text: String, sender: UIViewController, completion: (() -> Void)? = nil) {
        Loaf(text, state: .custom(.init(backgroundColor: .systemGreen, icon: UIImage(systemName: "star.fill"), textAlignment: .center, width: .screenPercentage(0.7))), location: .bottom,  sender: sender).show(.short)
    }
    
}

  

    

