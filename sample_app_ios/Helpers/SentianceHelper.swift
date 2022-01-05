//
//  SentianceHelper.swift
//  sample_app_ios
//
//  Created by Rameshwaran B on 2021-12-07.
//

import SENTSDK

class SentianceHelper {
    struct SetupSDKConfig {
        var shouldLinkUser: Bool
        var appId: String
        var appSecret: String
        var baseUrl: String?
    }

    // setupSdk sets the booolean flag to setup the sdk
    // It also sets the flag to indicate if user linking is enabled
    static func setupSdk (_ config: SetupSDKConfig) {
        Store.setBool(true, forKey: "SentianceIsSdkEnabled")
        Store.setBool(config.shouldLinkUser, forKey: "SentianceEnableUserLinking")
        Store.setStr(config.appId, forKey: "SentianceAppId")
        Store.setStr(config.appSecret, forKey: "SentianceAppSecret")

        if let baseUrl = config.baseUrl {
            Store.setStr(baseUrl, forKey: "SentianceBaseUrl")
        }
        
        self.initSdk()
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

    static func initSdk() {
        // The app id and secret are retrieved from the store
        let appId: String = Store.getStr("SentianceAppId")
        let appSecret: String = Store.getStr("SentianceAppSecret")

        // If the app id an secret are empty return the fun tion as the app has not been setup yet
        if (appId == "" || appSecret == "") {
            return
        }

        let isSdkEnabled = Store.getBool("SentianceIsSdkEnabled")
        let isUserLinkingEnabled = Store.getBool("SentianceEnableUserLinking")

        // Do not proceeed if the sdk is not enabled
        if (!isSdkEnabled) {
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
        if (isUserLinkingEnabled) {
            let metaUserLink: MetaUserLinker = { installId, linkSuccess, linkFailed in
                Store.setStr(installId!, forKey: "SentianceInstallId")
                HttpHelper.linkUser(installId!, completion:{
                    (linkResult) in
                    switch linkResult {
                    case let .success(data):
                        linkSuccess!()
                        print(data)
                        DataModelHelper.set()
                    case let .failure(error):
                        linkFailed!()
                        print("Error fetching config: \(error)")
                    }
                })
            }

            config = SENTConfig(appId: appId, secret: appSecret, link: metaUserLink)
        } else {
            config = SENTConfig(appId: appId, secret: appSecret)
        }

        if config != nil && Store.getStr("SentianceBaseUrl") != "" {
            config?.baseURL = Store.getStr("SentianceBaseUrl")
        }


        // Start the sdk if the initialisation succeeded
        SENTSDK.sharedInstance().initWith(config, success: {
            self.startSdk()

            DataModelHelper.set()
        },
        failure: { issue in
            DataModelHelper.setInitError(issue)
        })
    }
}


