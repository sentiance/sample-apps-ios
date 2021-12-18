//
//  SentianceHelper.swift
//  sample_app_ios
//
//  Created by Rameshwaran B on 2021-12-07.
//

import SENTSDK

class SentianceHelper {
    static var appId = Store.getStr("SentianceAppId")
    static var appSecret = Store.getStr("SentianceAppSecret")

    static func initSdk (shouldLinkUser: Bool) {
        Store.setBool(true, forKey: "SentianceIsSdkEnabled")
        Store.setBool(shouldLinkUser, forKey: "SentianceEnableUserLinking")
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
    
    static func startSdk() {
        SENTSDK.sharedInstance().start { status in
            _ = self.getStartStatus()
        }
    }
    
    static func resetSdk() {
        SENTSDK.sharedInstance().reset({
            print("SDK Reset success")
        }, failure: { issue in
            print("SDK Reset failure")
        })
    }

    static func fetchAndStoreConfig () {
        HttpHelper.fetchConfig {
            (configResult) in

            switch configResult {
            case let .success(config):
                Store.setStr(config.id, forKey: "SentianceAppId")
                Store.setStr(config.secret, forKey: "SentianceAppSecret")
                appId = config.id
                appSecret = config.secret

                self.setupSdk()
            case let .failure(error):
                print("Error fetching config: \(error)")
            }
        }
    }
    
    static func setupSdk() {
        if (appId == "" || appSecret == "") {
            self.fetchAndStoreConfig()

            return
        }
        
        let isSdkEnabled = Store.getBool("SentianceIsSdkEnabled")
        let isUserLinkingEnabled = Store.getBool("SentianceEnableUserLinking")

        if (!isSdkEnabled) {
            return
        }

        let state = self.getInitStatus()
        
        if (state == .SENTInitInProgress || state == .SENTResetting) {
            return
        }

        if (state == .SENTInitialized) {
            if let startStatus = getStartStatus() {
                if startStatus == .pending || startStatus == .started {
                    return
                } else if startStatus == .notStarted {
                    self.startSdk()
                    return
                }
            }
        }
        
        var config = SENTConfig(appId: self.appId, secret: self.appSecret)
        
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

        SENTSDK.sharedInstance().initWith(config, success: {
            let _ = self.getInitStatus()
            self.startSdk()
            
            DataModel.set()
        },
        failure: { issue in
            DataModelHelper.setInitError(issue)
        })
    }
}


