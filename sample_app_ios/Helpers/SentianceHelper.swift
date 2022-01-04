//
//  SentianceHelper.swift
//  sample_app_ios
//
//  Created by Rameshwaran B on 2021-12-07.
//

import SENTSDK

class SentianceHelper {
    // The app id and secret are retirved from the store if they are already present
    // else they are set as an empty string
    static var appId = Store.getStr("SentianceAppId")
    static var appSecret = Store.getStr("SentianceAppSecret")

    // setupSdk sets the booolean flag to setup the sdk
    // It also sets the flag to indicate if user linking is enabled
    static func setupSdk (_ shouldLinkUser: Bool, _ appId: String, _ appSecret: String, _ baseUrl: String) {
        Store.setBool(true, forKey: "SentianceIsSdkEnabled")
        Store.setBool(shouldLinkUser, forKey: "SentianceEnableUserLinking")
        Store.setStr(appId, forKey: "SentianceAppId")
        Store.setStr(appSecret, forKey: "SentianceAppSecret")
        Store.setStr(baseUrl, forKey: "SentianceBaseUrl")
        
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
        
        var config = SENTConfig(appId: self.appId, secret: self.appSecret)
        
        // If user linking is enabled update the config with the user link closure
        if (isUserLinkingEnabled) {
            let metaUserLink: MetaUserLinker = { installId, linkSuccess, linkFailed in
                DataModel.setInstallId(installId!)
                HttpHelper.linkUser(installId!, completion:{
                    (linkResult) in
                    switch linkResult {
                    case let .success(data):
                        linkSuccess!()
                        print(data)
                    case let .failure(error):
                        linkFailed!()
                        print("Error fetching config: \(error)")
                    }
                })
            }

            config = SENTConfig(appId: self.appId, secret: self.appSecret, link: metaUserLink)
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


