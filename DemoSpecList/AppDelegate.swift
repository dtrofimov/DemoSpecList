//
//  AppDelegate.swift
//  DemoSpecList
//
//  Created by Dmitrii Trofimov on 18-05-16.
//  Copyright © 2018 Dmitrii Trofimov. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let docDocApiClient = DocDocApiClient()
        
        let vc = SpecListViewController()
        vc.docDocApiClient = docDocApiClient
        let navVc = UINavigationController(rootViewController: vc)
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = navVc
        window.makeKeyAndVisible()
        self.window = window
        
        return true
    }

}
