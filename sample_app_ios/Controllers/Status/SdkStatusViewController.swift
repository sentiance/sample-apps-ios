//
//  SdkStatus.swift
//  sample_app_ios
//
//  Created by Rameshwaran B on 2021-12-07.
//

import UIKit
import SPPermissions

extension SPPermissionsListController {
    override public func viewWillDisappear(_ animated: Bool) {
        DataModelHelper.set()
    }
}

class SdkStatusViewController: UIViewController, DataDelegate {
    func dataChange() {
        DispatchQueue.main.async { [self] in
            reloadUIView()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DataModelHelper.set()
    }
    
    @objc func handleResetSdkTap(sender: UITapGestureRecognizer) {
        SentianceHelper.resetSdk()
        DataModelHelper.set()
    }
    
    @objc func handleRetryInitTap(sender: UITapGestureRecognizer) {
        let shouldLinkUser = Store.getBool("SentianceUserLinkingEnabled")
        SdkHelper.createUser(shouldLinkUser)

        DataModelHelper.set()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (SPPermissions.Permission.locationAlways.status != .authorized || SPPermissions.Permission.motion.status != .authorized ) {
            let permissions: [SPPermissions.Permission] = [.locationAlways, .motion]
            let permissionController = SPPermissions.list(permissions)
            
            permissionController.titleText = "Permission"
            permissionController.headerText = "Please allow location and motion access"
            permissionController.footerText = "The above accesses are required"
                
            permissionController.present(on: self)
        }
    }
    
    func reloadUIView () {
        let headerView = addHeaderView()
        let statusUIView = StatusView()
        let contentView = statusUIView.addContentView(view, headerView: headerView)
        let stackView = statusUIView.addStackView(contentView)
        let inferenceView = statusUIView.getSdkInferenceView()
        let statusView = statusUIView.addStatusSection()
        let idView = statusUIView.addIdSection()
        let permissionView = statusUIView.addPermissionSection()
        let emptyView = statusUIView.getEmptyView()
        let errorTextView = statusUIView.getErrorTextView()
        
        stackView.addArrangedSubview(inferenceView)
        stackView.addArrangedSubview(statusView)
        stackView.addArrangedSubview(idView)
        stackView.addArrangedSubview(permissionView)
        
        if (DataModel.get().initError != "") {
            stackView.addArrangedSubview(errorTextView)
        }
        
        stackView.addArrangedSubview(emptyView)
        
        addFooterButton(stackView: stackView, statusView: statusUIView)
        
        statusView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 0).isActive = true
        statusView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 0).isActive = true
        idView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 0).isActive = true
        idView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 0).isActive = true
        permissionView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 0).isActive = true
        permissionView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 0).isActive = true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DataModel.delegate = self
        view.backgroundColor = UIColor(named: "gray_lighter")
        
        reloadUIView()
        
    }
    
    func addFooterButton (stackView: UIStackView, statusView: StatusView) {
        let resetButton: UIButton = statusView.getResetButtton()
        let resetTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleResetSdkTap(sender:)))
        resetButton.addGestureRecognizer(resetTapGesture)
        
        let retryButton: UIButton = statusView.getRetryButtton()
        let retryTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleRetryInitTap(sender:)))
        retryButton.addGestureRecognizer(retryTapGesture)
        
        if (StatusHelper.getInitStatus() == .SENTInitialized) {
            if let startStatus = StatusHelper.getStartStatus() {
                if startStatus != .notStarted {
                    stackView.addArrangedSubview(resetButton)
                }
            }
        } else {
            stackView.addArrangedSubview(retryButton)
        }
    }
}
