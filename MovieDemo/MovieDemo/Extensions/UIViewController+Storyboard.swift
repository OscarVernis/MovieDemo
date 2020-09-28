//
//  UIViewController+Storyboard.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 15/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

extension UIViewController {
    static func instantiateFromStoryboard(_ storyboard: UIStoryboard? = nil) -> Self {
        let newStoryboard = storyboard != nil ? storyboard! : UIStoryboard(name: String(describing: self), bundle: .main)
    
        return newStoryboard.instantiateViewController(identifier: String(describing: self))
    }
}
