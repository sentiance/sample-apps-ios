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
    func application(
        _: UIApplication,
        didFinishLaunchingWithOptions _: [UIApplication
            .LaunchOptionsKey: Any]?
    ) -> Bool {
        // Override point for customization after application launch.

        // Sentiance SDK is expected to run in the background
        // Hence we initialise it in the background in addition to the foreground initialisation
        SentianceHelper.initSdk { issue in
            // DO NOT COPY THE BODY OF THIS FUNCTION
            //
            // Include your app specific workflow you would like
            // to be invoked on SDK initialization
            DataModelHelper.initCallback(issue)
        }

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(
        _: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options _: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(
            name: "Default Configuration",
            sessionRole: connectingSceneSession.role
        )
    }

    func application(
        _: UIApplication,
        didDiscardSceneSessions _: Set<UISceneSession>
    ) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}
