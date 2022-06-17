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
    private var sessionManager = SessionManager.shared

    override func showHome() {
        let homeView = Home(coordinator: self)        
        let hvc = UIHostingController(rootView: homeView)
        
        let searchViewController = SearchViewController(coordinator: self)
        hvc.navigationItem.searchController = searchViewController.searchController
        
        rootNavigationViewController?.viewControllers = [hvc]
    }
    
    override func showUserProfile(animated: Bool = true) {
        if let sessionId = sessionManager.sessionId {
            let user = UserViewModel(service: RemoteUserLoader(sessionId: sessionId), cache: nil)
            let userProfile = UserProfile(user: user, coordinator: self)
            let upvc = UIHostingController(rootView: userProfile)

            rootNavigationViewController?.pushViewController(upvc, animated: animated)
        } else {
            showLogin(animated: animated)
        }
    }
    
}
