//
//  AppDelegate.swift
//  sample_app_ios
//
//  Created by Rameshwaran B on 2021-12-04.
//

import SENTSDK
import UIKit

@main

class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        initializeSentianceSDK(launchOptions: launchOptions)
        return true
    }
    
    private func initializeSentianceSDK(launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        // Initialize Sentiance in appDelegate in order to register backgroundTasks.
        let options = SENTOptions(for: .appLaunch)
        let initializationResult = Sentiance.shared.initialize(options: options, launchOptions: launchOptions)
        if initializationResult.isSuccessful {
            print("[SDK]: Initialization successful")
        } else {
            print("[SDK]: Initialization failed, reason: \(initializationResult.failureReason)")
        }
    }

    // MARK: UISceneSession Lifecycle

    func application(_: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options _: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_: UIApplication, didDiscardSceneSessions _: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}
