//
//  UIViewController+Storyboard.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 15/09/20.
//  Copyright © 2020 Oscar Vernis. All rights reserved.
//

import UIKit

extension UIViewController {
    static func instantiateFromStoryboard(_ storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: .main)) -> Self {
        return storyboard.instantiateViewController(identifier: String(describing: self))
    }
}
