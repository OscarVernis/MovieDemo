//
//  AppDelegate.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 7/12/19.
//  Copyright © 2019 Oscar Vernis. All rights reserved.
//

import UIKit
import MagicalRecord

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        MagicalRecord.setLoggingLevel(.off)
        MagicalRecord.setupCoreDataStack(withAutoMigratingSqliteStoreNamed: "MovieDB.sqlite")
        
        return true
    }

}

