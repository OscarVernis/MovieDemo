//
//  UIViewController+Storyboard.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 15/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

extension UIViewController {
    static func instantiateFromStoryboard(named: String? = nil, identifier: String? = nil) -> Self {
        let storyboardName = named ?? String(describing: self)
        let viewControllerIdentifier = identifier ?? String(describing: self)
        
        let storyboard = UIStoryboard(name: storyboardName, bundle: .main)
    
        return storyboard.instantiateViewController(identifier: viewControllerIdentifier)
    }
}
