//
//  SentianceHelper.swift
//  sample_app_ios
//
//  Created by Rameshwaran B on 2021-12-07.
//

import SENTSDK

class SentianceHelper {
    typealias InitCb = (SENTInitIssue?) -> Void

    struct SDKParams {
        var appId: String // Sentiance application id
        var appSecret: String // Sentiance application secret
        var baseUrl: String? // Sentiance base url
        var link: MetaUserLinker? // Function that will be called to link the external user id and Sentiance user id
        var initCb: InitCb? // A callback function that is to be called when initialisation succeeds or fails
    }

    /**
        Saves the app id, app secret and base url to the store. It creates the user, initialises and starts the Sentiance SDK.
        This method is used when we want to create user.

        - parameter params: SDKParams which includes app id, secret, base url, optional link function and optional init callback
     */
    static func createUser(_ params: SDKParams) {
        Store.setStr(params.appId, forKey: "SentianceAppId")
        Store.setStr(params.appSecret, forKey: "SentianceAppSecret")

        if let baseUrl = params.baseUrl {
            Store.setStr(baseUrl, forKey: "SentianceBaseUrl")
        }

        configureSdk(params)
    }

    // Starts the sdk
    static func startSdk() {
        SENTSDK.sharedInstance().start { _ in
            // Can log the start status here or do something with it
        }
    }

    // Resets the sdk and removes the existing user installation
    static func resetSdk() {
        SENTSDK.sharedInstance().reset({
            print("SDK Reset success")
        }, failure: { _ in
            print("SDK Reset failure")
        })
    }

    /**
        Initialises and starts the sdk if it is not already initialised

        - parameter params: SDKParams which includes app id, secret, base url, optional link function and optional init callback
     */
    static func configureSdk(_ params: SDKParams) {
        // If the app id an secret are empty return the function
        if params.appId == "" || params.appSecret == "" {
            return
        }

        let state = SENTSDK.sharedInstance().getInitState()

        // Sdk throws error if we try to initialise an already initialised sdk
        // Do not proceed if the sdk init is in progress or if the sdk is resetting
        if state == .SENTInitialized || state == .SENTInitInProgress || state == .SENTResetting {
            return
        }

        var config: SENTConfig?

        // If link function is given as a part of Sdk config param, create the SENTConfig object with the link function
        // Else, create the SENTConfig object without the link function
        if params.link != nil {
            config = SENTConfig(appId: params.appId, secret: params.appSecret, link: params.link)
        } else {
            config = SENTConfig(appId: params.appId, secret: params.appSecret)
        }

        if config != nil, Store.getStr("SentianceBaseUrl") != "" {
            config?.baseURL = Store.getStr("SentianceBaseUrl")
        }

        // Initialise the sdk
        SENTSDK.sharedInstance().initWith(config, success: {
            // Start the sdk if the initialisation succeeds
            self.startSdk()

            // If initialisation callback is present in config param, call it
            if let cb = params.initCb {
                cb(nil)
            }
        },
        failure: { issue in
            // If initialisation callback is present in config param, call it with the error
            if let cb = params.initCb {
                cb(issue)
            }
        })
    }

    /**
        Initialises the Sentiance SDK. This method is called only once
        in the entire codebase, specifically in the application(_:didFinishLaunchingWithOptions:)
        method. This invocation ensures that the Sentiance SDK can continue detecting while
        the application in the background.

        - parameter initCallback: An optional callback
     */
    static func initSdk(_ initCallback: SentianceHelper.InitCb?) {
        // The app id and secret are retrieved from the store
        let appId: String = Store.getStr("SentianceAppId")
        let appSecret: String = Store.getStr("SentianceAppSecret")
        let baseUrl: String = Store.getStr("SentianceBaseUrl")
        let setupSdkConfig = SDKParams(appId: appId, appSecret: appSecret, baseUrl: baseUrl, link: nil, initCb: initCallback)

        configureSdk(setupSdkConfig)
    }
}
