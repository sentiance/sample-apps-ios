//
//  SdkStatus.swift
//  sample_app_ios
//
//  Created by Rameshwaran B on 2021-12-07.
//

import SENTSDK
import SPPermissions
import UIKit

public extension SPPermissionsListController {
    override func viewWillDisappear(_: Bool) {
        DataModelHelper.set()
    }
}

class SdkStatusViewController: UIViewController, DataDelegate {
    func dataChange() {
        DispatchQueue.main.async { [self] in
            reloadUIView()
        }
    }

    override func viewWillAppear(_: Bool) {
        DataModelHelper.set()
    }

    @objc func handleResetSdkTap(sender _: UITapGestureRecognizer) {
        SENTSDK.sharedInstance().reset(
            {
                print("SDK Reset success")
            },
            failure: { _ in
                print("SDK Reset failure")
            }
        )
        DataModelHelper.set()
    }

    @objc func handleStartAgainTap(sender _: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }

    override func viewDidAppear(_: Bool) {
        if SPPermissions.Permission.locationAlways
            .status != .authorized || SPPermissions.Permission.motion
            .status != .authorized
        {
            let permissions: [SPPermissions.Permission] =
                [.locationAlways, .motion]
            let permissionController = SPPermissions.list(permissions)

            permissionController.titleText = "Permission"
            permissionController
                .headerText =
                "Please allow location and motion access"
            permissionController
                .footerText = "The above accesses are required"

            permissionController.present(on: self)
        }
    }

    func reloadUIView() {
        for view in view.subviews {
            view.removeFromSuperview()
        }

        let headerView = addHeaderView()
        let statusUIView = StatusView()
        let contentView = statusUIView.addContentView(
            view,
            headerView: headerView
        )
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
        if DataModel.get().initError != "" {
            stackView.addArrangedSubview(errorTextView)
        }
        stackView.addArrangedSubview(emptyView)

        addFooterButton(
            stackView: stackView,
            statusView: statusUIView
        )

        statusView.leadingAnchor.constraint(
            equalTo: stackView.leadingAnchor
        ).isActive = true
        statusView.trailingAnchor.constraint(
            equalTo: stackView.trailingAnchor
        ).isActive = true
        idView.leadingAnchor.constraint(
            equalTo: stackView.leadingAnchor
        ).isActive = true
        idView.trailingAnchor.constraint(
            equalTo: stackView.trailingAnchor
        ).isActive = true
        permissionView.leadingAnchor.constraint(
            equalTo: stackView.leadingAnchor
        ).isActive = true
        permissionView.trailingAnchor.constraint(
            equalTo: stackView.trailingAnchor
        ).isActive = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        DataModel.delegate = self
        view.backgroundColor = UIColor(named: "gray_lighter")

        reloadUIView()
    }

    func addFooterButton(
        stackView: UIStackView,
        statusView: StatusView
    ) {
        let resetButton: UIButton = statusView.getResetButtton()
        let resetTapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(handleResetSdkTap(sender:))
        )
        resetButton.addGestureRecognizer(resetTapGesture)

        let startAgainButton: UIButton = statusView
            .getStartAgainButtton()
        let startAgainTapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(handleStartAgainTap(sender:))
        )
        startAgainButton.addGestureRecognizer(startAgainTapGesture)

        if StatusHelper.getInitStatus() == .SENTInitialized {
            if let startStatus = StatusHelper.getStartStatus() {
                if startStatus != .notStarted {
                    stackView.addArrangedSubview(resetButton)
                }
            }
        } else {
            stackView.addArrangedSubview(startAgainButton)
        }
    }
}
