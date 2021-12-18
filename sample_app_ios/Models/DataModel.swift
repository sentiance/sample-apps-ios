//
//  Data.swift
//  sample_app_ios
//
//  Created by Rameshwaran B on 2021-12-10.
//

import SPPermissions
import SENTSDK

protocol DataDelegate{
    func dataChange()
}

class DataModel {
    
    static var delegate:DataDelegate? = nil
    
    enum Status {
        case success
        case warn
        case danger
    }
    
    struct Data {
        var value: String
        var status: Status
    }
    
    struct DataModel {
        var initError: String
        var sdkInference: Data
        var sdkInitStatus: Data
        var sdkStartStatus: Data
        var userId: String
        var installId: String
        var externalId: String
        var locationPermission: Data
        var motionPermission: Data
        var permissionInference: Data
    }
    
    static var data = DataModel(
        initError: "",
        sdkInference: Data(value: "Not Collecting data", status: .danger),
        sdkInitStatus: Data(value: "Not Initialised", status: .danger),
        sdkStartStatus: Data(value: "Not Started", status: .danger),
        userId: "",
        installId: "",
        externalId: "",
        locationPermission: Data(value: "Denied", status: .danger),
        motionPermission: Data(value: "Denied", status: .danger),
        permissionInference: Data(value: "App will not work optimally", status: .danger)
    ) {
        didSet {
            delegate?.dataChange()
            print("The value of myProperty changed from \(oldValue) to \(data)")
        }
    }

    static func setInitError (_ val: String) {
        data.initError = val
    }
    
    static func setExternalId (_ val: String) {
        data.externalId = val
    }
    
    static func setInstallId (_ val: String) {
        data.installId = val
    }
    
    static func setUserId (_ val: String) {
        data.userId = val
    }
    
    static func setLocationPermission (_ val: Data) {
        data.locationPermission = val
    }
    
    static func setMotionPermission (_ val: Data) {
        data.motionPermission = val
    }
    
    static func setPermissionInference (_ val: Data) {
        data.permissionInference = val
    }
    
    static func setSdkInitStatus (_ val: Data) {
        data.sdkInitStatus = val
    }
    
    static func setSdkStartStatus (_ val: Data) {
        data.sdkStartStatus = val
    }
    
    static func setSdkInitStatus() {
        let state = SentianceHelper.getInitStatus()
        
        switch state {
        case .SENTNotInitialized:
            data.sdkInitStatus = Data(value: "Not initialised", status: .danger)
        case .SENTInitialized:
            data.sdkInitStatus = Data(value: "Initialised", status: .success)
        case .SENTInitInProgress:
            data.sdkInitStatus = Data(value: "In progress", status: .danger)
        case .SENTResetting:
            data.sdkInitStatus = Data(value: "Resetting", status: .danger)
        @unknown default:
            data.sdkInitStatus = Data(value: "Not initialised", status: .danger)
        }
    }
    
    static func setSdkStartStatus() {
        let sdkStatus = SentianceHelper.getStartStatus()

        if let status = sdkStatus {
            switch status {
            case SENTStartStatus.notStarted:
                data.sdkStartStatus = Data(value: "Not started", status: .danger)
                data.sdkInference = Data(value: "Not collecting data", status: .danger)
            case SENTStartStatus.pending:
                data.sdkStartStatus = Data(value: "Pending", status: .danger)
                data.sdkInference = Data(value: "Not collecting data", status: .danger)
            case SENTStartStatus.started:
                data.sdkStartStatus = Data(value: "Started", status: .success)
                data.sdkInference = Data(value: "Collecting data", status: .success)
            case SENTStartStatus.expired:
                data.sdkStartStatus = Data(value: "Expired", status: .danger)
                data.sdkInference = Data(value: "Not collecting data", status: .danger)
            @unknown default:
                data.sdkStartStatus = Data(value: "Not started", status: .danger)
                data.sdkInference = Data(value: "Not collecting data", status: .danger)
            }
        } else {
            data.sdkStartStatus = Data(value: "Not started", status: .danger)
            data.sdkInference = Data(value: "Not collecting data", status: .danger)
        }

    }

    static func get () -> DataModel {
        return data
    }

    static func set () {
        if SPPermissions.Permission.locationAlways.status == .authorized {
            setLocationPermission(Data(value: "ALWAYS", status: .success))
        } else {
            if (SPPermissions.Permission.locationWhenInUse.status == .authorized) {
                setLocationPermission(Data(value: "WHEN IN USE", status: .warn))
            } else {
                setLocationPermission(Data(value: "DENIED", status: .danger))
            }
        }
        
        if SPPermissions.Permission.motion.status == .authorized {
            setMotionPermission(Data(value: "ALWAYS", status: .success))
        } else {
            setMotionPermission(Data(value: "DENIED", status: .danger))
        }
        
        if SPPermissions.Permission.locationAlways.status == .authorized && SPPermissions.Permission.motion.status == .authorized {
            setPermissionInference(Data(value: "All permissions provided", status: .success))
        } else {
            setPermissionInference(Data(value: "App will not work optimally", status: .danger))
        }
        
        setSdkInitStatus()
        setSdkStartStatus()

        let initStatus = SentianceHelper.getInitStatus()
        
        if initStatus == .SENTInitialized {
            setInitError("")
        }

        if let userId = SENTSDK.sharedInstance().getUserId() {
            setUserId(userId)
        }

        if (!Store.getBool("SentianceEnableUserLinking")) {
            if let installId = SENTSDK.sharedInstance().getUserId() {
                setInstallId(installId)
            }
        }
    }
}
