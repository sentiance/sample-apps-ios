//
//  StatusHelper.swift
//  sample_app_ios
//
//  Created by Rameshwaran B on 2021-12-17.
//

import Foundation
import SENTSDK

class StatusHelper {
    static func logInitStatus(_ state: SENTSDKInitState) {
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
    }

    static func logStartStatus(_ status: SENTStartStatus) {
        switch status {
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
    }

    static func getUserId() -> String? {
        return SENTSDK.sharedInstance().getUserId()
    }

    static func getInitStatus() -> SENTSDKInitState {
        let state = SENTSDK.sharedInstance().getInitState()
        return state
    }

    static func getStartStatus() -> SENTStartStatus? {
        if let status = SENTSDK.sharedInstance().getStatus() {
            return status.startStatus
        }

        return nil
    }
}
