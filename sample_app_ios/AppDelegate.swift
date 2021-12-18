//
//  AppDelegate.swift
//  sample_app_ios
//
//  Created by Rameshwaran B on 2021-12-04.
//

import UIKit
import SENTSDK

@main

class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        // Assuming the user is logged in with the below username and password
        // The same is used for backend requests
        Store.setStr("dev-1", forKey: "AppUserName")
        Store.setStr("test", forKey: "AppUserPassword")

        // Sentiance SDK is expected to run in the background
        // Hence we initialise it in the background in addition to the foreground initialisation
        SentianceHelper.initSdk()

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

