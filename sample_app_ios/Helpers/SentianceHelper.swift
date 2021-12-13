//
//  SentianceHelper.swift
//  sample_app_ios
//
//  Created by Rameshwaran B on 2021-12-07.
//

import SENTSDK

class SentianceHelper {
    static let appId = ""
    static let appSecret = ""

    
    struct Settings: Codable {
      var isSdkEnabled: Bool
    }
    
    static let statusArchiveURL: URL = {
        let documentsDirectories =
            FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        return documentDirectory.appendingPathComponent("isSdkEnabled.plist")
    }()
    
    static func initSdk () {
        let settings = Settings(isSdkEnabled: true)
        
        do {
            let encoder = PropertyListEncoder()
            let data = try encoder.encode(settings)
            try data.write(to: self.statusArchiveURL, options: [.atomic])
        }
        catch let encodingError {
            print("Error encoding allItems: \(encodingError)")
        }
    }
    
    static func isSdkEnabled () -> Bool {
        var decodeData: Settings?
        if let data = try? Data(contentsOf: statusArchiveURL) {
          let decoder = PropertyListDecoder()
            decodeData = try? decoder.decode(Settings.self, from: data)
            if let _ = decodeData?.isSdkEnabled {
                return true
            }
        }
        return false
    }
    
    static func getState() -> SENTSDKInitState {
        let state = SENTSDK.sharedInstance().getInitState()
        
        switch state {
        case .SENTNotInitialized:
            print("SDK not initialized")
        case .SENTInitialized:
            print("SDK initialized")
        case .SENTInitInProgress:
            print("SDK init in progress")
        case .SENTResetting:
            print("SDK resetting")
        @unknown default:
            print("Status unknown")
        }
        
        return state
    }
    
    static func getStartStatus(_ status: SENTSDKStatus?) -> SENTStartStatus? {
        if let status = status {
            switch status.startStatus {
            case SENTStartStatus.notStarted:
                print("SDK Status: Not started")
            case SENTStartStatus.pending:
                print("SDK Status: Pending")
            case SENTStartStatus.started:
                print("SDK Status: Started")
            case SENTStartStatus.expired:
                print("SDK Status: Expired")
            @unknown default:
                print("Status unknown")
            }
            
            return status.startStatus
        }
        
        return nil
    }
    
    static func startSdk() {
        SENTSDK.sharedInstance().start { status in
            _ = self.getStartStatus(status)
        }
    }
    
    static func stopSdk() {
        SENTSDK.sharedInstance().stop()
    }
    
    static func setupSdk() {
        if (!self.isSdkEnabled()) {
            print("Click the init button to enable sdk")
            return
        }
        
        let state = self.getState()
        
        if (state != .SENTNotInitialized) {
            if let startStatus = getStartStatus(SENTSDK.sharedInstance().getStatus()) {
                if startStatus == .pending {
                    print("SDK start is pending")
                    return
                } else if startStatus == .started {
                    print("SDK already started")
                    return
                } else if startStatus == .notStarted {
                    print("SDK not started. So starting it now")
                    self.startSdk()
                    return
                }
            }
        }
        
        let config = SENTConfig(appId: self.appId, secret: self.appSecret)
        
        SENTSDK.sharedInstance().initWith(config, success: {
            // Successful
            // Add code to start service.
            print("SDK Initialised")
            DataModel.setInitError("")
            let _ = self.getState()
            
            self.startSdk()
            
        },
        failure: { issue in
            debugPrint(issue)
            print(issue.rawValue)
            print("Failed to Initialize SDK with issue: \(issue)")

            switch issue {
            case .invalidCredentials:
                DataModel.setInitError("App id and secret used for init are invalid. Please verify them.")
            case .changedCredentials:
                DataModel.setInitError("Please verify the correctness of the credentials. Maybe you used different app id and secret before. Try to uninstall the app and reinstall the app again.")
            case .serviceUnreachable:
                DataModel.setInitError("Sentiance API service unreachable")
            case .linkFailed:
                DataModel.setInitError("User linking failed")
            case .resetInProgress:
                DataModel.setInitError("Reset in progress")
            @unknown default:
                DataModel.setInitError("Unknown error")
            }
        })
    }
}


