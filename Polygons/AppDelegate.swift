//
//  AppDelegate.swift
//  Polygons
//
//  Created by Krzysztof Lech on 14/10/2019.
//  Copyright © 2019 Krzysztof Lech. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var coordinator: MainCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        coordinator = MainCoordinator(window: window)
        coordinator?.start()
        
        return true
    }
}
