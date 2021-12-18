//
//  DataModelHelper.swift
//  sample_app_ios
//
//  Created by Rameshwaran B on 2021-12-17.
//

import Foundation
import SENTSDK

class DataModelHelper {
    static func setInitError(_ issue: SENTInitIssue) {
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
    }

}
