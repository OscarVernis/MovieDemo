//
//  UIViewController+NavBarAppearance.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 03/08/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import UIKit

extension UIViewController {
    func configureHomeTitleNavigationBarAppearance() {
        configureWithDefaultNavigationBarAppearance()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.standardAppearance.titleTextAttributes = [
            .font: UIFont(name: "AvenirNextCondensed-DemiBold", size: 22)!
        ]
        navigationController?.navigationBar.standardAppearance.largeTitleTextAttributes = [
            .font: UIFont(name: "AvenirNextCondensed-Bold", size: 34)!,
        ]
    }
    
    func configureWithDefaultNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.standardAppearance.titleTextAttributes = [
            .font: UIFont(name: "Avenir Next Medium", size: 20)!
        ]
    }
    
    func configureWithTransparentNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        navigationController?.navigationBar.standardAppearance = appearance
    }
}
