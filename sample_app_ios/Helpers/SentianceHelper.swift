//
//  SentianceHelper.swift
//  sample_app_ios
//
//  Created by Rameshwaran B on 2021-12-07.
//

import SENTSDK

class SentianceHelper {
    struct SDKConfigParams {
        var appId: String
        var appSecret: String
        var baseUrl: String?
        var link: MetaUserLinker?
        var initCb: SdkHelper.InitCb?
    }

    static func getConfigParams (_ appId: String, _ appSecret: String, _ baseUrl: String?, _ link: MetaUserLinker?, _ initCb: SdkHelper.InitCb?) -> SDKConfigParams {
        return self.SDKConfigParams(appId: appId, appSecret: appSecret, baseUrl: baseUrl, link: link, initCb: initCb)
    }

    // setupSdk sets the booolean flag to setup the sdk
    // It also sets the flag to indicate if user linking is enabled
    static func setupSdk (_ param: SDKConfigParams) {
        Store.setStr(param.appId, forKey: "SentianceAppId")
        Store.setStr(param.appSecret, forKey: "SentianceAppSecret")

        if let baseUrl = param.baseUrl {
            Store.setStr(baseUrl, forKey: "SentianceBaseUrl")
        }
        
        self.configureSdk(param)
    }
    
    // startSdk starts the sdk after sdk initialization
    static func startSdk() {
        SENTSDK.sharedInstance().start { status in
            // Can log the start status here or do something with it
        }
    }
    
    // resetSdk resets the sdk
    static func resetSdk() {
        SENTSDK.sharedInstance().reset({
            print("SDK Reset success")
        }, failure: { issue in
            print("SDK Reset failure")
        })
    }

    static func configureSdk(_ param: SDKConfigParams) {
        // If the app id an secret are empty return the fun tion as the app has not been setup yet
        if (param.appId == "" || param.appSecret == "") {
            return
        }

        let state = SENTSDK.sharedInstance().getInitState()

        // Sdk throws error if we try to initialise as already initialised sdk
        // Do not proceed if the sdk init is in progress or if if sdk is resetting
        if (state == .SENTInitialized || state == .SENTInitInProgress || state == .SENTResetting) {
            return
        }

        var config: SENTConfig?
        
        // If user linking is enabled update the config with the user link closure
        if (param.link != nil) {
            config = SENTConfig(appId: param.appId, secret: param.appSecret, link: param.link)
        } else {
            config = SENTConfig(appId: param.appId, secret: param.appSecret)
        }

        if config != nil && Store.getStr("SentianceBaseUrl") != "" {
            config?.baseURL = Store.getStr("SentianceBaseUrl")
        }

        // Start the sdk if the initialisation succeeded
        SENTSDK.sharedInstance().initWith(config, success: {
            self.startSdk()

            if let cb = param.initCb {
                cb(nil)
            }
        },
        failure: { issue in
            if let cb = param.initCb {
                cb(issue)
            }
        })
    }

    static func initSdk(_ initCallback: SdkHelper.InitCb?) {
        // The app id and secret are retrieved from the store
        let appId: String = Store.getStr("SentianceAppId")
        let appSecret: String = Store.getStr("SentianceAppSecret")
        let baseUrl: String = Store.getStr("SentianceBaseUrl")
        let setupSdkConfig = self.getConfigParams(appId, appSecret, baseUrl, nil, initCallback)

        self.configureSdk(setupSdkConfig)
    }
}


