//
//  SdkHelper.swift
//  sample_app_ios
//
//  Created by Rameshwaran B on 2022-01-05.
//

import SENTSDK

class SdkHelper {
    // createUser retrieves the app id and secret from the backend if it is not already stored in store
    // The app id and secret are retrieved to initialise the sdk
    static func createUser(_ shouldLinkUser: Bool) {
        let baseUrl = "https://api.sentiance.com"

        HttpHelper.fetchConfig {
            configResult in
            switch configResult {
            case let .success(config):
                var config = SentianceHelper.SDKParams(appId: config.id, appSecret: config.secret, baseUrl: baseUrl, link: nil, initCb: self.initCallback)

                if shouldLinkUser {
                    config.link = self.linkFn
                }

                SentianceHelper.createUser(config)
            case let .failure(error):
                print("Error fetching config: \(error)")
            }
        }
    }

    static let linkFn: MetaUserLinker = { installId, linkSuccess, linkFailed in
        Store.setStr(installId!, forKey: "SentianceInstallId")
        HttpHelper.linkUser(installId!, completion: {
            linkResult in
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

    static let initCallback: SentianceHelper.InitCb = { issue in
        if let issue = issue {
            DataModelHelper.setInitError(issue)
        } else {
            DataModelHelper.set()
        }
    }
}
