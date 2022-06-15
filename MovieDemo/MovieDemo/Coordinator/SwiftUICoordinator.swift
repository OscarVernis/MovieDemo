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
        
        rootNavigationViewController?.viewControllers = [hvc]
    }
    
}
