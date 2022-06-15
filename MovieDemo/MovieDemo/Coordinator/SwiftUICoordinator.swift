//
//  SwiftUICoordinator.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 15/06/22.
//  Copyright © 2022 Oscar Vernis. All rights reserved.
//

import UIKit
import SwiftUI

class SwiftUICoordinator: MainCoordinator {
    override func showHome() {
        let homeView = Home(coordinator: self)        
        let hvc = UIHostingController(rootView: homeView)
        
        let searchViewController = SearchViewController(coordinator: self)
        hvc.navigationItem.searchController = searchViewController.searchController
        
        rootNavigationViewController?.viewControllers = [hvc]
    }
    
}
