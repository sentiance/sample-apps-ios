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
        let appId: String = Store.getStr("SentianceAppId")
        let appSecret: String = Store.getStr("SentianceAppSecret")
        let baseUrl: String = Store.getStr("SentianceBaseUrl")
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
    /// his method should, ideally, be called when the SDK needs to come into action.
    /// e.g on user registration, on login or on accessing a particular feature.
    ///
    /// Note: Calling this method multiple times will not cause multiple sentiance users to be created
    ///
    /// - Parameter SDKParams: The SDK Params

    static func createUser(_ params: SDKParams) {
        Store.setStr(params.appId, forKey: "SentianceAppId")
        Store.setStr(params.appSecret, forKey: "SentianceAppSecret")

        if let baseUrl = params.baseUrl {
            Store.setStr(baseUrl, forKey: "SentianceBaseUrl")
        }

        configureSdk(params)
    }

    ///    Starts the SDK. Use this method on successfully invocation of "createUser"
    static func startSdk() {
        SENTSDK.sharedInstance().start { _ in
            // Can log the start status here or do something with it
        }
    }

    /// Resets the SDK
    ///
    /// Ideally, this method should be called when a user logs out of the application. Or when the SDK is required to be reinitialized

    static func resetSdk() {
        SENTSDK.sharedInstance().reset(
            {
                print("SDK Reset success")
            },
            failure: { _ in
                print("SDK Reset failure")
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

        if state == .SENTInitialized || state == .SENTInitInProgress
            || state == .SENTResetting
        {
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

        if config != nil, Store.getStr("SentianceBaseUrl") != "" {
            config?.baseURL = Store.getStr("SentianceBaseUrl")
        }

        SENTSDK.sharedInstance().initWith(
            config,
            success: {
                self.startSdk()

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
