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
        let state: Loaf.State = (color == nil) ? .error : .custom(customStyle(color: color!, image: image))
        
        Loaf(title,
             state: state,
             location: .bottom,
             sender: sender)
        .show(.average) { _ in
            completion?()
        }
    }
    
    private static func customStyle(color: UIColor, image: UIImage? = nil) -> Loaf.Style {
        return .init(backgroundColor: color,
                     icon: image,
                     textAlignment: .natural,
                     width: .screenPercentage(0.7))
    }
    
}
