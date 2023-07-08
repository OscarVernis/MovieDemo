//
//  UIWindow+Utils.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 11/06/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import UIKit
extension UIWindow {
    static var mainWindow: UIWindow {
        (UIApplication.shared.delegate as! AppDelegate).window!
    }
    
    var topInset: CGFloat {
        safeAreaInsets.top
    }
    
    var bottomInset: CGFloat {
        safeAreaInsets.bottom
    }
}


