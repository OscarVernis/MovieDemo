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
    
    static func showNetworkConnectionAlert(sender: UIViewController) {
        Loaf(.localized(.NetworkConnectionError), state: .error, location: .bottom, presentingDirection: .vertical, dismissingDirection: .vertical, sender: sender).show(.short)
        
    }
    
    static func showRefreshErrorAlert(text: String = .localized(.RefreshError), sender: UIViewController, completion: (() -> Void)? = nil) {
        Loaf(text, state: .error, location: .bottom, presentingDirection: .vertical, dismissingDirection: .vertical, sender: sender).show(.short) { _ in
            completion?()
        }
    }
    
    static func showFavoriteAlert(text: String, sender: UIViewController, completion: (() -> Void)? = nil) {
        Loaf(text, state: .custom(.init(backgroundColor: .asset(.FavoriteColor), icon: UIImage(systemName: "heart.fill"), textAlignment: .natural, width: .screenPercentage(0.7))), location: .bottom,  sender: sender).show(.short)
    }
    
    static func showWatchlistAlert(text: String, sender: UIViewController, completion: (() -> Void)? = nil) {
        Loaf(text, state: .custom(.init(backgroundColor: .asset(.WatchlistColor), icon: UIImage(systemName: "bookmark.fill"), textAlignment: .natural, width: .screenPercentage(0.7))), location: .bottom,  sender: sender).show(.short)
    }
    
    
    static func showRatingAlert(text: String, sender: UIViewController, completion: (() -> Void)? = nil) {
        Loaf(text, state: .custom(.init(backgroundColor: .asset(.RatingColor), icon: UIImage(systemName: "star.fill"), textAlignment: .natural, width: .screenPercentage(0.7))), location: .bottom,  sender: sender).show(.short)
    }
    
}
