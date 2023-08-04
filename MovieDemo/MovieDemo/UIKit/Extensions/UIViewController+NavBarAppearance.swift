//
//  UIViewController+NavBarAppearance.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 03/08/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import UIKit

extension UIViewController {
    func configureWithDefaultNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        navigationController?.navigationBar.standardAppearance = appearance
    }
    
    func configureWithTransparentNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        navigationController?.navigationBar.standardAppearance = appearance
    }
}
