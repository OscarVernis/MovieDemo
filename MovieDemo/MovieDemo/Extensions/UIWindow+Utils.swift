//
//  UIWindow+Utils.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 11/06/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import UIKit
extension UIWindow {
    static var topInset: CGFloat {
        UIApplication.shared.windows.first(where: \.isKeyWindow)!.safeAreaInsets.top
    }
    
    static var bottomInset: CGFloat {
        UIApplication.shared.windows.first(where: \.isKeyWindow)!.safeAreaInsets.bottom
    }
}


