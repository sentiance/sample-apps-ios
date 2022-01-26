//
//  StatusView.swift
//  sample_app_ios
//
//  Created by Rameshwaran B on 2021-12-11.
//

import UIKit

class StatusView {
    func addPermissionSection() -> UIView {
        let viewContainer: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = .white
            view.layer.cornerRadius = 8
            return view
        }()

        let permissionView: UIStackView = {
            let view = UIStackView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.distribution = .fill
            view.spacing = 8
            view.axis = .vertical
            return view
        }()

        let statusHeaderLabel: UILabel = {
            let label = UILabel()
            label.backgroundColor = .white
            label.text = "Permission status"
            label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.heightAnchor.constraint(equalToConstant: 16).isActive = true
            return label
        }()

        let locationContainer: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()

        let locationWrapper: UIStackView = {
            let view = UIStackView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.distribution = .equalCentering
            view.axis = .horizontal
            return view
        }()

        locationContainer.addSubview(locationWrapper)

        locationWrapper.leadingAnchor.constraint(equalTo: locationContainer.leadingAnchor).isActive = true
        locationWrapper.trailingAnchor.constraint(equalTo: locationContainer.trailingAnchor).isActive = true
        locationWrapper.topAnchor.constraint(equalTo: locationContainer.topAnchor).isActive = true
        locationWrapper.bottomAnchor.constraint(equalTo: locationContainer.bottomAnchor).isActive = true

        let locationLabel: UILabel = {
            let label = UILabel()
            label.backgroundColor = .white
            label.text = "Location"
            label.textColor = UIColor(named: "gray_default")
            label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.heightAnchor.constraint(equalToConstant: 32).isActive = true
            return label
        }()

        let locationStatusLabel: UILabel = {
            let label = UILabel()
            label.backgroundColor = .white
            let state = DataModel.get().locationPermission
            label.textColor = Utility.getTextColor(state.status)
            label.text = state.value

            label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.heightAnchor.constraint(equalToConstant: 32).isActive = true
            return label
        }()

        locationWrapper.addArrangedSubview(locationLabel)
        locationWrapper.addArrangedSubview(locationStatusLabel)

        let motionContainer: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()

        let motionWrapper: UIStackView = {
            let view = UIStackView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.distribution = .equalCentering
            view.axis = .horizontal
            return view
        }()

        motionContainer.addSubview(motionWrapper)

        motionWrapper.leadingAnchor.constraint(equalTo: motionContainer.leadingAnchor
        ).isActive = true
        motionWrapper.trailingAnchor.constraint(equalTo: motionContainer.trailingAnchor).isActive = true
        motionWrapper.topAnchor.constraint(equalTo: motionContainer.topAnchor).isActive = true
        motionWrapper.bottomAnchor.constraint(equalTo: motionContainer.bottomAnchor).isActive = true

        let motionLabel: UILabel = {
            let label = UILabel()
            label.backgroundColor = .white
            label.text = "Motion"
            label.textColor = UIColor(named: "gray_default")
            label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.heightAnchor.constraint(equalToConstant: 16).isActive = true
            return label
        }()

        let motionStatusLabel: UILabel = {
            let label = UILabel()
            label.backgroundColor = .white

            let state = DataModel.get().motionPermission
            label.textColor = Utility.getTextColor(state.status)
            label.text = state.value
            label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.heightAnchor.constraint(equalToConstant: 16).isActive = true
            return label
        }()

        let statusLabel: UITextView = {
            let label = UITextView()
            label.backgroundColor = .white

            let state = DataModel.get().permissionInference
            label.textColor = Utility.getTextColor(state.status)
            label.text = state.value

            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            label.heightAnchor.constraint(equalToConstant: 16).isActive = true
            return label
        }()

        motionWrapper.addArrangedSubview(motionLabel)
        motionWrapper.addArrangedSubview(motionStatusLabel)

        permissionView.addArrangedSubview(statusHeaderLabel)
        permissionView.addArrangedSubview(locationContainer)
        permissionView.addArrangedSubview(motionContainer)
        permissionView.addArrangedSubview(statusLabel)

        viewContainer.addSubview(permissionView)

        permissionView.topAnchor.constraint(equalTo: viewContainer.topAnchor, constant: 10).isActive = true
        permissionView.bottomAnchor.constraint(equalTo: viewContainer.bottomAnchor, constant: -10).isActive = true
        permissionView.leadingAnchor.constraint(equalTo: viewContainer.leadingAnchor, constant: 10).isActive = true
        permissionView.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor, constant: -10).isActive = true

        viewContainer.heightAnchor.constraint(equalToConstant: 126).isActive = true

        return viewContainer
    }

    func addIdSection() -> UIView {
        let viewContainer: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = .white
            view.layer.cornerRadius = 8
            return view
        }()

        let idView: UIStackView = {
            let view = UIStackView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.distribution = .fill
            view.axis = .vertical
            view.spacing = 10

            return view
        }()

        let userIdHeaderLabel: UILabel = {
            let label = UILabel()
            label.text = "User ID"
            label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.heightAnchor.constraint(equalToConstant: 16).isActive = true
            return label
        }()

        let userIdLabel: UILabel = {
            let label = UILabel()
            label.text = DataModel.get().userId
            label.textColor = UIColor(named: "gray_default")
            label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.heightAnchor.constraint(equalToConstant: 16).isActive = true
            return label
        }()

        let installIdHeaderLabel: UILabel = {
            let label = UILabel()
            label.text = "Install ID"
            label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.heightAnchor.constraint(equalToConstant: 16).isActive = true
            return label
        }()

        let installIdLabel: UILabel = {
            let label = UILabel()
            label.textColor = UIColor(named: "gray_default")
            label.text = DataModel.get().installId
            label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.heightAnchor.constraint(equalToConstant: 16).isActive = true
            return label
        }()

        idView.addArrangedSubview(userIdHeaderLabel)
        idView.addArrangedSubview(userIdLabel)
        idView.addArrangedSubview(installIdHeaderLabel)
        idView.addArrangedSubview(installIdLabel)

        viewContainer.addSubview(idView)

        idView.topAnchor.constraint(equalTo: viewContainer.topAnchor, constant: 10).isActive = true
        idView.bottomAnchor.constraint(equalTo: viewContainer.bottomAnchor, constant: -10).isActive = true
        idView.leadingAnchor.constraint(equalTo: viewContainer.leadingAnchor, constant: 12).isActive = true
        idView.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor, constant: -12).isActive = true

        viewContainer.heightAnchor.constraint(equalToConstant: 116).isActive = true

        return viewContainer
    }

    func addStatusSection() -> UIView {
        let viewContainer: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = .white
            view.layer.cornerRadius = 8
            return view
        }()

        let statusStackView: UIStackView = {
            let view = UIStackView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.distribution = .fill
            view.axis = .vertical
            view.spacing = 10
            return view
        }()

        let initStatusView: UIStackView = {
            let view = UIStackView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.distribution = .fill
            view.axis = .vertical
            view.spacing = 10
            return view
        }()

        let initStatusHeaderLabel: UILabel = {
            let label = UILabel()
            label.backgroundColor = .white
            label.text = "Init Status"
            label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.heightAnchor.constraint(equalToConstant: 16).isActive = true
            return label
        }()

        let initStatusLabelContainer: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = .white
            view.heightAnchor.constraint(equalToConstant: 44).isActive = true
            return view
        }()

        let initStatusLabelWrapper: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false

            let initState = DataModel.get().sdkInitStatus

            view.backgroundColor = Utility.getBgColor(initState.status)
            view.layer.cornerRadius = 8
            return view
        }()

        let initStatusLabel: UILabel = {
            let label = UILabel()

            let initState = DataModel.get().sdkInitStatus
            label.textColor = Utility.getDarkTextColor(initState.status)
            label.text = initState.value

            label.font = UIFont.systemFont(ofSize: 20, weight: .light)

            label.translatesAutoresizingMaskIntoConstraints = false

            return label
        }()

        let initStatusBorder: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = UIColor(named: "gray_light")
            view.heightAnchor.constraint(equalToConstant: 1).isActive = true
            return view
        }()

        initStatusLabelContainer.addSubview(initStatusLabelWrapper)
        initStatusLabelWrapper.addSubview(initStatusLabel)

        initStatusView.addArrangedSubview(initStatusHeaderLabel)
        initStatusView.addArrangedSubview(initStatusLabelContainer)
        initStatusView.addArrangedSubview(initStatusBorder)

        initStatusBorder.leadingAnchor.constraint(equalTo: initStatusView.leadingAnchor
        ).isActive = true
        initStatusBorder.trailingAnchor.constraint(equalTo: initStatusView.trailingAnchor).isActive = true

        initStatusLabelWrapper.widthAnchor.constraint(equalToConstant: initStatusLabel.intrinsicContentSize.width + 20).isActive = true
        initStatusLabelWrapper.heightAnchor.constraint(equalToConstant: initStatusLabel.intrinsicContentSize.height + 20).isActive = true

        initStatusLabel.centerXAnchor.constraint(equalTo: initStatusLabelWrapper.centerXAnchor).isActive = true
        initStatusLabel.centerYAnchor.constraint(equalTo: initStatusLabelWrapper.centerYAnchor).isActive = true

        let sdkStatusView: UIStackView = {
            let view = UIStackView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.distribution = .fill
            view.axis = .vertical
            view.spacing = 10
            return view
        }()

        let sdkStatusHeaderLabel: UILabel = {
            let label = UILabel()
            label.backgroundColor = .white
            label.text = "SDK Status"
            label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.heightAnchor.constraint(equalToConstant: 16).isActive = true
            return label
        }()

        let sdkStatusLabelContainer: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = .clear
            view.heightAnchor.constraint(equalToConstant: 44).isActive = true

            return view
        }()

        let sdkStatusLabelWrapper: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            let sdkStatus = DataModel.get().sdkStartStatus

            view.backgroundColor = Utility.getBgColor(sdkStatus.status)
            view.layer.cornerRadius = 8

            return view
        }()

        let sdkStatusLabel: UILabel = {
            let label = UILabel()
            let sdkStatus = DataModel.get().sdkStartStatus

            label.textColor = Utility.getDarkTextColor(sdkStatus.status)
            label.text = sdkStatus.value
            label.font = UIFont.systemFont(ofSize: 20, weight: .light)
            label.translatesAutoresizingMaskIntoConstraints = false

            return label
        }()

        sdkStatusLabelContainer.addSubview(sdkStatusLabelWrapper)
        sdkStatusLabelWrapper.addSubview(sdkStatusLabel)
        sdkStatusLabelWrapper.widthAnchor.constraint(equalToConstant: sdkStatusLabel.intrinsicContentSize.width + 20).isActive = true
        sdkStatusLabelWrapper.heightAnchor.constraint(equalToConstant: sdkStatusLabel.intrinsicContentSize.height + 20).isActive = true

        sdkStatusLabel.centerXAnchor.constraint(equalTo: sdkStatusLabelWrapper.centerXAnchor).isActive = true
        sdkStatusLabel.centerYAnchor.constraint(equalTo: sdkStatusLabelWrapper.centerYAnchor).isActive = true

        sdkStatusView.addArrangedSubview(sdkStatusHeaderLabel)
        sdkStatusView.addArrangedSubview(sdkStatusLabelContainer)
        statusStackView.addArrangedSubview(initStatusView)
        statusStackView.addArrangedSubview(sdkStatusView)

        viewContainer.addSubview(statusStackView)

        statusStackView.topAnchor.constraint(equalTo: viewContainer.topAnchor, constant: 10).isActive = true
        statusStackView.bottomAnchor.constraint(equalTo: viewContainer.bottomAnchor, constant: -10).isActive = true
        statusStackView.leadingAnchor.constraint(equalTo: viewContainer.leadingAnchor, constant: 12).isActive = true
        statusStackView.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor, constant: -12).isActive = true

        viewContainer.heightAnchor.constraint(equalToConstant: 182).isActive = true

        return viewContainer
    }

    func getSdkInferenceView() -> UITextView {
        let textView = UITextView()
        textView.textAlignment = NSTextAlignment.center
        textView.backgroundColor = .white
        textView.layer.cornerRadius = 8
        let state = DataModel.get().sdkInference
        textView.textColor = Utility.getTextColor(state.status)
        textView.text = state.value
        textView.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        return textView
    }

    func getErrorTextView() -> UITextView {
        let textView = UITextView()
        textView.layer.cornerRadius = 8
        textView.backgroundColor = .white
        textView.textAlignment = NSTextAlignment.center
        textView.textColor = UIColor(named: "red_default")
        textView.text = DataModel.get().initError
        textView.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        textView.heightAnchor.constraint(equalToConstant: 52).isActive = true
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }

    func getResetButtton() -> UIButton {
        let button = UIButton()
        button.setTitle("Reset Sdk", for: .normal)
        button.backgroundColor = UIColor(named: "blue_primary")
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        button.setTitleColor(UIColor.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 8
        return button
    }

    func getRetryButtton() -> UIButton {
        let button = UIButton()
        button.setTitle("Retry", for: .normal)
        button.backgroundColor = UIColor(named: "blue_primary")
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        button.setTitleColor(UIColor.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 8
        return button
    }

    func addContentView(_ view: UIView, headerView: UIView) -> UIView {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(contentView)
        let contentConstraints = [
            contentView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
        ]
        NSLayoutConstraint.activate(contentConstraints)

        return contentView
    }

    func addStackView(_ contentView: UIView) -> UIStackView {
        let stackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.spacing = 8
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.isLayoutMarginsRelativeArrangement = true
            stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 0)

            return stackView
        }()

        contentView.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true

        return stackView
    }

    func getEmptyView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setContentHuggingPriority(UILayoutPriority.defaultLow, for: .vertical)
        return view
    }
}
