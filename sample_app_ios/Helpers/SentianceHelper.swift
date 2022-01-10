//
//  SentianceHelper.swift
//  sample_app_ios
//
//  Created by Rameshwaran B on 2021-12-07.
//

import SENTSDK

class SentianceHelper {
    typealias InitCb = (SENTInitIssue?) -> Void

    struct SDKConfigParams {
        var appId: String // Sentiance application id
        var appSecret: String // Sentiance application secret
        var baseUrl: String? // Sentiance base url
        var link: MetaUserLinker? // Function that will be called to link the external user id and Sentiance user id
        var initCb: InitCb? // A callback function that is to be called when initialisation succeeds or fails
    }

    // getConfigParams constructs the SDK config from the given parameters
    static func getConfigParams (_ appId: String, _ appSecret: String, _ baseUrl: String?, _ link: MetaUserLinker?, _ initCb: InitCb?) -> SDKConfigParams {
        return self.SDKConfigParams(appId: appId, appSecret: appSecret, baseUrl: baseUrl, link: link, initCb: initCb)
    }

    // createUser saves the app id, app secret and base url to the store and calls the
    // configureSdk which initialises and starts the sdk if it is not already initialised and started
    static func createUser (_ param: SDKConfigParams) {
        Store.setStr(param.appId, forKey: "SentianceAppId")
        Store.setStr(param.appSecret, forKey: "SentianceAppSecret")

        if let baseUrl = param.baseUrl {
            Store.setStr(baseUrl, forKey: "SentianceBaseUrl")
        }
        
        self.configureSdk(param)
    }
    
    // startSdk starts the sdk
    static func startSdk() {
        SENTSDK.sharedInstance().start { status in
            // Can log the start status here or do something with it
        }
    }
    
    // resetSdk resets the sdk and removes the existing user installation
    static func resetSdk() {
        SENTSDK.sharedInstance().reset({
            print("SDK Reset success")
        }, failure: { issue in
            print("SDK Reset failure")
        })
    }

    // configureSdk initialises and starts the sdk if it is not already initialised
    // 1. Return the function if the app id or secret is empty
    // 2. Return the function if the sdk is already initialised
    // 3. Create the SENTConfig object which will be used to initialise the sdk
    // 4. Initialise the Sdk
    // 5. If initialisation is successful, start the sdk and call the initialisation callback if it is present in config param
    // 6. If initialisation fails, call initialisation callback with the error if it is present in config param
    static func configureSdk(_ param: SDKConfigParams) {
        // If the app id an secret are empty return the function
        if (param.appId == "" || param.appSecret == "") {
            return
        }

        let state = SENTSDK.sharedInstance().getInitState()

        // Sdk throws error if we try to initialise an already initialised sdk
        // Do not proceed if the sdk init is in progress or if the sdk is resetting
        if (state == .SENTInitialized || state == .SENTInitInProgress || state == .SENTResetting) {
            return
        }

        var config: SENTConfig?
        
        // If link function is given as a part of Sdk config param, create the SENTConfig object with the link function
        // Else, create the SENTConfig object without the link function
        if (param.link != nil) {
            config = SENTConfig(appId: param.appId, secret: param.appSecret, link: param.link)
        } else {
            config = SENTConfig(appId: param.appId, secret: param.appSecret)
        }

        if config != nil && Store.getStr("SentianceBaseUrl") != "" {
            config?.baseURL = Store.getStr("SentianceBaseUrl")
        }

        // Initialise the sdk
        SENTSDK.sharedInstance().initWith(config, success: {
            // Start the sdk if the initialisation succeeds
            self.startSdk()

            // If initialisation callback is present in config param, call it
            if let cb = param.initCb {
                cb(nil)
            }
        },
        failure: { issue in
            // If initialisation callback is present in config param, call it with the error
            if let cb = param.initCb {
                cb(issue)
            }
        })
    }

    // initSdk gets the app id, app secret and base url from the store
    // It calls configureSdk which initialises and starts the sdk if it is not already initialised
    static func initSdk(_ initCallback: InitCb?) {
        // The app id and secret are retrieved from the store
        let appId: String = Store.getStr("SentianceAppId")
        let appSecret: String = Store.getStr("SentianceAppSecret")
        let baseUrl: String = Store.getStr("SentianceBaseUrl")
        let setupSdkConfig = self.getConfigParams(appId, appSecret, baseUrl, nil, initCallback)

        self.configureSdk(setupSdkConfig)
    }
}


