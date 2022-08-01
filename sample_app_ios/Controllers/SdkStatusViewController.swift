//
//  SdkStatus.swift
//  sample_app_ios
//
//  Created by Rameshwaran B on 2021-12-07.
//

import SPPermissions
import SENTSDK
import CoreMotion

class SdkStatusViewController: UIViewController {
    
    @IBOutlet weak var detectionsRunningIndicator: UIView!
    @IBOutlet weak var detectionsRunningLabel: UILabel!
    @IBOutlet weak var initStatus: UILabel!
    @IBOutlet weak var initStatusIndicator: UIView!
    @IBOutlet weak var detectionStatus: UILabel!
    @IBOutlet weak var detectionStatusIndicator: UIView!
    @IBOutlet weak var userId: UILabel!
    @IBOutlet weak var locationPermission: UILabel!
    @IBOutlet weak var motionPermission: UILabel!
    @IBOutlet weak var permissionStatus: UILabel!
    @IBOutlet weak var givePermissionButton: UIButton!
    
    
    @IBAction func copyUserIdToClipboard(_ sender: UIButton) {
        if let userId = userId.text {
            UIPasteboard.general.string = userId
            showMessage(message: "Copied: \(userId)")
        }
    }
    
    @IBAction func resetSdk(_ sender: Any) {
        Sentiance.shared.reset { resetResult, resetError in
            if let resetError = resetError {
                self.showMessage(message: "Failed to reset sdk, error: \(resetError.failureReason)")
            }
            else {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @IBAction func onGivePermissions(_ sender: Any) {
        showPermissionDialog()
    }
    
    private func showPermissionDialog() {
        let permissions: [SPPermissions.Permission] = [.locationAlways, .motion]
        let permissionController = SPPermissions.list(permissions)
        
        permissionController.titleText = "Permission"
        permissionController.headerText = "Please allow location and motion access"
        permissionController.footerText = "The above accesses are required"
        navigationController?.pushViewController(permissionController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Sentiance.shared.setDidReceiveSdkStatusUpdateHandler { sdkStatus in
            self.updateUI(sdkStatus: sdkStatus)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.updateUI(sdkStatus: Sentiance.shared.sdkStatus)
    }
    
    private func updateUI(sdkStatus: SENTSDKStatus) {
        updateDetectionAndDataColloectionStatus(sdkStatus: sdkStatus)
        updateInitStatus()
        updatePermissionStatus(sdkLocationPermission: sdkStatus.locationPermission)
        showHidePermissionButton()
        userId.text = Sentiance.shared.userId
    }
    
    private func updateDetectionAndDataColloectionStatus(sdkStatus: SENTSDKStatus) {
        let detectionStatusIndicatorColor: UIColor = sdkStatus.detectionStatus == .enabledAndDetecting ? .green : .red
        let dataCollectionStatusText = sdkStatus.detectionStatus == .enabledAndDetecting ? "Detections are running" : "Detections are not running"
        detectionsRunningLabel.text = dataCollectionStatusText
        detectionsRunningIndicator.backgroundColor = detectionStatusIndicatorColor
        detectionStatusIndicator.backgroundColor = detectionStatusIndicatorColor
        detectionStatus.text = detectionStatusToString(detectionStatus: sdkStatus.detectionStatus)
    }
    
    private func updateInitStatus() {
        let initState = Sentiance.shared.initState
        let initStatusIndicatorColor: UIColor = initState == .initialized ? .green : .red
        initStatusIndicator.backgroundColor = initStatusIndicatorColor
        initStatus.text = initStateToString(initState: initState)
    }
    
    private func updatePermissionStatus(sdkLocationPermission: SENTLocationPermission) {
        let locationPermissionTextColor: UIColor = sdkLocationPermission == .always ? .green : .red
        locationPermission.textColor = locationPermissionTextColor
        locationPermission.text = locationPermissionStatusToString(locationPermission: sdkLocationPermission)
        
        let motionPermissionGranted = isMotionPermissionGranted()
        let motionPermissionTextColor: UIColor = motionPermissionGranted ? .green : .red
        motionPermission.textColor = motionPermissionTextColor
        motionPermission.text = motionPermissionGranted ? "Granted" : "Not Granted"
        
        let permissionsOk = isMotionPermissionGranted() && isLocationPermissionGranted()
        let permissionStatusTextColor: UIColor = permissionsOk ? .blue : .red
        permissionStatus.textColor = permissionStatusTextColor
        permissionStatus.text = permissionsOk ? "All permissions are granted" : "Missing permission(s)"
        
    }
    
    private func showHidePermissionButton() {
        givePermissionButton.isHidden = allPermissionsGranted()
    }
    
    private func allPermissionsGranted() -> Bool {
        return isMotionPermissionGranted() && isLocationPermissionGranted()
    }
    
    private func isMotionPermissionGranted() -> Bool {
        CMMotionActivityManager.authorizationStatus()
        return CMMotionActivityManager.authorizationStatus() == .authorized
    }
    
    private func isLocationPermissionGranted() -> Bool {
        return Sentiance.shared.sdkStatus.locationPermission == .always
    }
    
    private func locationPermissionStatusToString(locationPermission: SENTLocationPermission) -> String {
        switch (locationPermission) {
        case .always:
            return "always"
        case .whileInUse:
            return "whileInUse"
        case .never:
            return "never"
        @unknown default:
            return "unknown"
        }
    }
    private func initStateToString(initState: SENTSDKInitState) -> String {
        switch(initState) {
        case .notInitialized:
            return "NotInitialized"
        case .inProgress:
            return "InitInProgress"
        case .initialized:
            return "Initialized"
        case .resetting:
            return "Resetting"
        @unknown default:
            return "Unknown"
        }
    }
    
    private func detectionStatusToString(detectionStatus: SENTDetectionStatus) -> String {
        switch(detectionStatus) {
        case .disabled:
            return "disabled"
        case .expired:
            return "expired"
        case .enabledButBlocked:
            return "enabledButBlocked"
        case .enabledAndDetecting:
            return "enabledAndDetecting"
        @unknown default:
            return "unknown"
        }
    }
}
