//
//  AppDelegate.swift
//  Orbi
//
//  Created by adb on 6/8/19.
//  Copyright © 2019 Arena. All rights reserved.
//

import UIKit
import SideMenuSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        configureSideMenu()
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        BleSingleton.shared.bleManager.disconnectFromDevice()
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    private func configureSideMenu() {
        SideMenuController.preferences.basic.menuWidth = 246
        SideMenuController.preferences.basic.defaultCacheKey = "0"
        SideMenuController.preferences.basic.supportedOrientations = .landscape
        SideMenuController.preferences.basic.enablePanGesture = false
        SideMenuController.preferences.basic.position = .sideBySide
        SideMenuController.preferences.basic.direction = .right
        SideMenuController.preferences.basic.hideMenuWhenEnteringBackground = false        
    }

}


