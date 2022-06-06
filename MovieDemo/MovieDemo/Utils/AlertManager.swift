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
    static func showErrorAlert(_ title: String, color: UIColor? = nil, image: UIImage? = nil, sender: UIViewController, completion: (() -> Void)? = nil) {
        var state = Loaf.State.error
        if let color = color {
            state = .custom(.init(backgroundColor: color,
                                            icon: image,
                                            textAlignment: .natural,
                                            width: .screenPercentage(0.7)))
        }
        
        Loaf(title,
             state: state,
             location: .bottom,
             sender: sender)
        .show(.short) { _ in
            completion?()
        }
    }
    
    static func showRefreshErrorAlert(text: String = .localized(.RefreshError), sender: UIViewController, completion: (() -> Void)? = nil) {
        Loaf(text, state: .error, location: .bottom, presentingDirection: .vertical, dismissingDirection: .vertical, sender: sender).show(.short) { _ in
            completion?()
        }
    }
    
    static func showFavoriteAlert(text: String, sender: UIViewController, completion: (() -> Void)? = nil) {
        Loaf(text,
             state: .custom(.init(backgroundColor: .asset(.FavoriteColor),
                                  icon: .asset(.heart),
                                  textAlignment: .natural,
                                  width: .screenPercentage(0.7))),
             location: .bottom,
             sender: sender).show(.short)
    }
    
    static func showWatchlistAlert(text: String, sender: UIViewController, completion: (() -> Void)? = nil) {
        Loaf(text, state: .custom(.init(backgroundColor: .asset(.WatchlistColor), icon: .asset(.bookmark), textAlignment: .natural, width: .screenPercentage(0.7))), location: .bottom,  sender: sender).show(.short)
    }
    
    
    static func showRatingAlert(text: String, sender: UIViewController, completion: (() -> Void)? = nil) {
        Loaf(text, state: .custom(.init(backgroundColor: .asset(.RatingColor), icon: .asset(.star), textAlignment: .natural, width: .screenPercentage(0.7))), location: .bottom,  sender: sender).show(.short)
    }
    
}
