//
//  AppDelegate.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 7/12/19.
//  Copyright © 2019 Oscar Vernis. All rights reserved.
//

import UIKit
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var appCoordinator: MainCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow()
        self.window = window
        
        Alamofire.Session.default.session.configuration.timeoutIntervalForRequest = 1
        Alamofire.Session.default.session.configuration.timeoutIntervalForResource = 1

        appCoordinator = MainCoordinator(window: window)
        appCoordinator?.start()
        
        return true
    }

}

