//
//  SentianceHelper.swift
//  sample_app_ios
//
//  Created by Rameshwaran B on 2021-12-07.
//

import SENTSDK

/// A small helper library to optimise the integration of the SDK
///
/// ~~~
/// This library primarily exposes
///
/// - "init" method: To be called only once, and in  the application(_:didFinishLaunchingWithOptions:) method
/// - "createUser" method: To be called when the SDK needs to come into play e.g when a user logs in
/// ~~~

class SentianceHelper {
    typealias InitCb = (SENTInitIssue?) -> Void

    struct SDKParams {
        // Sentiance APP ID
        var appId: String

        // Sentiance APP Secret
        var appSecret: String

        // Optional Sentiance Platform's Base URL
        var baseUrl: String?

        // Optional method to handle external user linking
        var link: MetaUserLinker?

        // Optional callback
        var initCb: InitCb?
    }

    /// Initialises the Sentiance SDK. This method should be called only once in the entire codebase,
    /// specifically in the application(_:didFinishLaunchingWithOptions:) method.
    /// This invocation ensures that the Sentiance SDK can continue detecting while the
    /// application in the background.
    ///
    /// - Parameter initCallback: An optional callback

    static func initSdk(_ initCallback: SentianceHelper.InitCb?) {
        let appId: String = SentianceStore.getStr("SentianceAppId")
        let appSecret: String = SentianceStore
            .getStr("SentianceAppSecret")
        let baseUrl: String = SentianceStore
            .getStr("SentianceBaseUrl")
        let setupSdkConfig = SDKParams(
            appId: appId,
            appSecret: appSecret,
            baseUrl: baseUrl,
            link: nil,
            initCb: initCallback
        )

        configureSdk(setupSdkConfig)
    }

    /// Creates a sentiance user for the application.
    ///
    /// This method should, ideally, be called when the SDK needs to come into action.
    /// e.g on user registration, on login or on accessing a particular feature.
    ///
    /// Note: Calling this method multiple times will not cause multiple sentiance users to be created
    ///
    /// - Parameter SDKParams: The SDK Params

    static func createUser(_ params: SDKParams) {
        SentianceStore.setStr(params.appId, forKey: "SentianceAppId")
        SentianceStore.setStr(
            params.appSecret,
            forKey: "SentianceAppSecret"
        )

        if let baseUrl = params.baseUrl {
            SentianceStore.setStr(baseUrl, forKey: "SentianceBaseUrl")
        }

        configureSdk(params)
    }

    /// Resets the Sentiance SDK
    ///
    /// This method should, ideally, be called to logout the user
    static func reset() {
        SENTSDK.sharedInstance().reset(
            {
                // You can do some action when SDK reset succeeds
            },
            failure: { _ in
                // You can do some action when SDK reset fails
            }
        )
    }

    ///   Internal method use to configure the Sentiance SDK.
    ///
    ///   You should not need to call this method from externally.
    ///
    ///   Notes:
    ///   - Skips if credentials are not presents
    ///   - Skips if the sdk is already initialised or is in process
    ///
    ///   - Parameter params: SDKParams

    private static func configureSdk(_ params: SDKParams) {
        if params.appId == "" || params.appSecret == "" {
            return
        }

        let state = SENTSDK.sharedInstance().getInitState()

        if state == .SENTInitialized {
            if let cb = params.initCb {
                cb(nil)
            }

            return
        }

        var config: SENTConfig?

        if params.link != nil {
            config = SENTConfig(
                appId: params.appId,
                secret: params.appSecret,
                link: params.link
            )
        } else {
            config = SENTConfig(
                appId: params.appId,
                secret: params.appSecret
            )
        }

        if SentianceStore.getStr("SentianceBaseUrl") != ""
        {
            config?.baseURL = SentianceStore
                .getStr("SentianceBaseUrl")
        }

        SENTSDK.sharedInstance().initWith(
            config,
            success: {
                SENTSDK.sharedInstance().start { _ in
                    // You can include any app specific code you would like
                    // e.g. log the "start status", etc
                }

                if let cb = params.initCb {
                    cb(nil)
                }
            },
            failure: { issue in
                if let cb = params.initCb {
                    cb(issue)
                }
            }
        )
    }
}

/// Utlity class to store values to user defaults
enum SentianceStore {
    static func setStr(_ value: String, forKey: String) {
        UserDefaults.standard.set(value, forKey: forKey)
    }

    static func getStr(_ forKey: String) -> String {
        if let data = UserDefaults.standard.string(forKey: forKey) {
            return data
        }
        return ""
    }

    static func setBool(_ value: Bool, forKey: String) {
        UserDefaults.standard.set(value, forKey: forKey)
    }

    static func getBool(_ key: String) -> Bool {
        return UserDefaults.standard.bool(forKey: key)
    }
}
