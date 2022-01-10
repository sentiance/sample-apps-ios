//
//  Data.swift
//  sample_app_ios
//
//  Created by Rameshwaran B on 2021-12-10.
//

protocol DataDelegate {
    func dataChange()
}

class DataModel {
    static var delegate: DataDelegate?

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
        }
    }

    static func setInitError(_ val: String) {
        data.initError = val
    }

    static func setExternalId(_ val: String) {
        data.externalId = val
    }

    static func setInstallId(_ val: String) {
        data.installId = val
    }

    static func setUserId(_ val: String) {
        data.userId = val
    }

    static func setLocationPermission(_ value: String, status: Status) {
        data.locationPermission = Data(value: value, status: status)
    }

    static func setMotionPermission(_ value: String, status: Status) {
        data.motionPermission = Data(value: value, status: status)
    }

    static func setPermissionInference(_ value: String, status: Status) {
        data.permissionInference = Data(value: value, status: status)
    }

    static func setSdkInitStatus(_ value: String, status: Status) {
        data.sdkInitStatus = Data(value: value, status: status)
    }

    static func setSdkStartStatus(_ value: String, status: Status) {
        data.sdkStartStatus = Data(value: value, status: status)
    }

    static func setSdkInference(_ value: String, status: Status) {
        data.sdkInference = Data(value: value, status: status)
    }

    static func get() -> DataModel {
        return data
    }
}
