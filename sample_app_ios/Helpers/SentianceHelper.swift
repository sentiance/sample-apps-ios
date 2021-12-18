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
    static func setupSdk (shouldLinkUser: Bool) {
        Store.setBool(true, forKey: "SentianceIsSdkEnabled")
        Store.setBool(shouldLinkUser, forKey: "SentianceEnableUserLinking")
    }
    
    static func getUserId() -> String? {
        return SENTSDK.sharedInstance().getUserId()
    }

    static func getInitStatus() -> SENTSDKInitState {
        let state = SENTSDK.sharedInstance().getInitState()
        StatusHelper.logInitStatus(state)
        return state
    }
    
    static func getStartStatus() -> SENTStartStatus? {
        if let status = SENTSDK.sharedInstance().getStatus() {
            StatusHelper.logStartStatus(status.startStatus)
            return status.startStatus
        }
        
        return nil
    }
    
    // startSdk starts the sdk after sdk initialization
    static func startSdk() {
        SENTSDK.sharedInstance().start { status in
            _ = self.getStartStatus()
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

    // fetchAndStoreConfig retrieves the app id and secret from the backend
    // The app id and secret are retrieved to initialise the sdk
    static func fetchAndStoreConfig () {
        HttpHelper.fetchConfig {
            (configResult) in

            switch configResult {
            case let .success(config):
                Store.setStr(config.id, forKey: "SentianceAppId")
                Store.setStr(config.secret, forKey: "SentianceAppSecret")
                appId = config.id
                appSecret = config.secret

                self.initSdk()
            case let .failure(error):
                print("Error fetching config: \(error)")
            }
        }
    }
    
    static func initSdk() {
        // If the app id an secret are empty retrieve them from the backend
        if (appId == "" || appSecret == "") {
            self.fetchAndStoreConfig()

            return
        }

        let isSdkEnabled = Store.getBool("SentianceIsSdkEnabled")
        let isUserLinkingEnabled = Store.getBool("SentianceEnableUserLinking")

        // Do not proceeed if the sdk is not enabled
        if (!isSdkEnabled) {
            return
        }

        let state = self.getInitStatus()
        
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
            let _ = self.getInitStatus()
            self.startSdk()
            
            DataModelHelper.set()
        },
        failure: { issue in
            DataModelHelper.setInitError(issue)
        })
    }
}


