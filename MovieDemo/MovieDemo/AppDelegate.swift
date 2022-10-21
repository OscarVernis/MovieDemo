//
//  AppDelegate.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 7/12/19.
//  Copyright © 2019 Oscar Vernis. All rights reserved.
//

import UIKit
import SDWebImage

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow? = UIWindow()
    
    lazy var appCoordinator: MainCoordinator = {
        SwiftUICoordinator(window: window!)
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        appCoordinator.start()
        
        return true
    }

}

