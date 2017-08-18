//
//  AppDelegate.swift
//  KittyGramTest
//
//  Created by Gabor on 06/07/2017.
//  Copyright © 2017 Gabor. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        let loginVC = LandingPageViewController()
    
        let nav = UINavigationController(rootViewController: loginVC)
        window?.rootViewController = nav
        
        return true
    }

}

