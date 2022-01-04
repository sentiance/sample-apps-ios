//
//  DataModelHelper.swift
//  sample_app_ios
//
//  Created by Rameshwaran B on 2021-12-17.
//

import Foundation
import SENTSDK
import SPPermissions

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

    static func setSdkInitStatus() {
        let state = StatusHelper.getInitStatus()

        switch state {
        case .SENTNotInitialized:
            DataModel.setSdkInitStatus("Not initialised", status: .danger)
        case .SENTInitialized:
            DataModel.setSdkInitStatus("Initialised", status: .success)
        case .SENTInitInProgress:
            DataModel.setSdkInitStatus("In progress", status: .danger)
        case .SENTResetting:
            DataModel.setSdkInitStatus("Resetting", status: .danger)
        @unknown default:
            DataModel.setSdkInitStatus("Not initialised", status: .danger)
        }
    }

    static func setSdkStartStatus() {
        let sdkStatus = StatusHelper.getStartStatus()

        if let status = sdkStatus {
            switch status {
            case SENTStartStatus.notStarted:
                DataModel.setSdkStartStatus("Not started", status: .danger)
                DataModel.setSdkInference("Not collecting data", status: .danger)
            case SENTStartStatus.pending:
                DataModel.setSdkStartStatus("Pending", status: .danger)
                DataModel.setSdkInference("Not collecting data", status: .danger)
            case SENTStartStatus.started:
                DataModel.setSdkStartStatus("Started", status: .success)
                DataModel.setSdkInference("Collecting data", status: .success)
            case SENTStartStatus.expired:
                DataModel.setSdkStartStatus("Expired", status: .danger)
                DataModel.setSdkInference("Not collecting data", status: .danger)
            @unknown default:
                DataModel.setSdkStartStatus("Not started", status: .danger)
                DataModel.setSdkInference("Not collecting data", status: .danger)
            }
        } else {
            DataModel.setSdkStartStatus("Not started", status: .danger)
            DataModel.setSdkInference("Not collecting data", status: .danger)
        }
    }

    static func set () {
        if SPPermissions.Permission.locationAlways.status == .authorized {
            DataModel.setLocationPermission("ALWAYS", status: .success)
        } else {
            if (SPPermissions.Permission.locationWhenInUse.status == .authorized) {
                DataModel.setLocationPermission("WHEN IN USE", status: .warn)
            } else {
                DataModel.setLocationPermission("DENIED", status: .danger)
            }
        }

        if SPPermissions.Permission.motion.status == .authorized {
            DataModel.setMotionPermission("ALWAYS", status: .success)
        } else {
            DataModel.setMotionPermission("DENIED", status: .danger)
        }

        if SPPermissions.Permission.locationAlways.status == .authorized && SPPermissions.Permission.motion.status == .authorized {
            DataModel.setPermissionInference("All permissions provided", status: .success)
        } else {
            DataModel.setPermissionInference("App will not work optimally", status: .danger)
        }

        DataModelHelper.setSdkInitStatus()
        DataModelHelper.setSdkStartStatus()

        let initStatus = StatusHelper.getInitStatus()

        if initStatus == .SENTInitialized {
            DataModel.setInitError("")
        }

        if let userId = StatusHelper.getUserId() {
            DataModel.setUserId(userId)
        }

        if (!Store.getBool("SentianceEnableUserLinking")) {
            if let installId = StatusHelper.getUserId() {
                DataModel.setInstallId(installId)
            }
        } else {
            DataModel.setInstallId(Store.getStr("SentianceInstallId"))
        }
    }
}
