//
//  HomeView.swift
//  sample_app_ios
//
//  Created by Rameshwaran B on 2021-12-12.
//

import UIKit

class HomeView {
    func getEmptyView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setContentHuggingPriority(UILayoutPriority.defaultLow, for: .vertical)
        return view
    }

    func getGreetingTextView() -> UITextView {
        let textView = UITextView()
        textView.textAlignment = NSTextAlignment.center
        textView.textColor = UIColor(named: "blue_primary")
        textView.backgroundColor = .clear
        textView.text = "Hello there!"
        textView.font = UIFont.systemFont(ofSize: 36, weight: .bold)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return textView
    }

    func getinitializationTextView() -> UITextView {
        let textView = UITextView()
        textView.textAlignment = NSTextAlignment.center
        textView.textColor = .black
        textView.backgroundColor = .clear
        textView.text = "Please select your initialization method"
        textView.font = UIFont.systemFont(ofSize: 14, weight: .light)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return textView
    }

    func addStackView(_ contentView: UIView) -> UIStackView {
        let stackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.spacing = 16
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 40, right: 0)
            stackView.isLayoutMarginsRelativeArrangement = true
            return stackView
        }()

        contentView.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true

        return stackView
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

    func addInitWithoutLinkBtn(_ stackView: UIStackView) -> UIView {
        let contentView: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = .white
            view.layer.cornerRadius = 8
            view.layer.borderWidth = 1
            view.layer.borderColor = UIColor(named: "blue_primary")?.cgColor
            return view
        }()

        let innerStackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.distribution = .fill
            stackView.translatesAutoresizingMaskIntoConstraints = false
            return stackView
        }()

        let btnContainer: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()

        let btnWrapper: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = UIColor(named: "blue_primary")?.withAlphaComponent(0.2)
            view.layer.cornerRadius = 30
            return view
        }()

        let btn: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = UIColor(named: "blue_primary")
            view.layer.cornerRadius = 24
            return view
        }()

        let imageView: UIImageView = {
            let originalImage = UIImage(named: "user_without_linking")!
            let resizingFactor = 10 / originalImage.size.height
            let newImage = UIImage(cgImage: originalImage.cgImage!, scale: originalImage.scale / resizingFactor, orientation: .up)
            let imageView = UIImageView(image: newImage)
            imageView.translatesAutoresizingMaskIntoConstraints = false

            return imageView
        }()

        let textView: UITextView = {
            let textView = UITextView()
            textView.contentInsetAdjustmentBehavior = .automatic
            textView.textAlignment = NSTextAlignment.center
            textView.textColor = UIColor(named: "blue_primary")
            textView.text = "Initialise SDK without user linking"
            textView.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
            textView.translatesAutoresizingMaskIntoConstraints = false
            textView.heightAnchor.constraint(equalToConstant: 30).isActive = true
            return textView
        }()

        contentView.addSubview(innerStackView)

        innerStackView.addArrangedSubview(btnContainer)
        innerStackView.addArrangedSubview(textView)

        btnContainer.addSubview(btnWrapper)
        btnWrapper.addSubview(btn)
        btn.addSubview(imageView)

        stackView.addArrangedSubview(contentView)

        let imageViewConstraints = [
            imageView.widthAnchor.constraint(equalToConstant: 20),
            imageView.heightAnchor.constraint(equalToConstant: 17),
            imageView.centerXAnchor.constraint(equalTo: btn.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: btn.centerYAnchor),
        ]

        NSLayoutConstraint.activate(imageViewConstraints)

        let btnConstrainsts = [
            btn.widthAnchor.constraint(equalToConstant: 48),
            btn.heightAnchor.constraint(equalToConstant: 48),
            btn.centerXAnchor.constraint(equalTo: btnWrapper.centerXAnchor),
            btn.centerYAnchor.constraint(equalTo: btnWrapper.centerYAnchor),
        ]

        NSLayoutConstraint.activate(btnConstrainsts)

        let btnContainerConstraints = [
            btnContainer.leadingAnchor.constraint(equalTo: innerStackView.leadingAnchor),
            btnContainer.trailingAnchor.constraint(equalTo: innerStackView.trailingAnchor),
        ]

        NSLayoutConstraint.activate(btnContainerConstraints)

        let btnWrapperConstraints = [
            btnWrapper.widthAnchor.constraint(equalToConstant: 60),
            btnWrapper.heightAnchor.constraint(equalToConstant: 60),
            btnWrapper.centerXAnchor.constraint(equalTo: btnContainer.centerXAnchor),
            btnWrapper.centerYAnchor.constraint(equalTo: btnContainer.centerYAnchor),
        ]

        NSLayoutConstraint.activate(btnWrapperConstraints)

        let contentViewConstraints = [
            contentView.heightAnchor.constraint(equalToConstant: 136),
            contentView.leadingAnchor.constraint(equalTo: stackView.layoutMarginsGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: stackView.layoutMarginsGuide.trailingAnchor),
        ]
        NSLayoutConstraint.activate(contentViewConstraints)

        let innerStackViewConstraints = [
            innerStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            innerStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            innerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            innerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ]

        NSLayoutConstraint.activate(innerStackViewConstraints)

        return contentView
    }

    func addInitWithLinkBtn(_ stackView: UIStackView) -> UIView {
        let contentView: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = .white
            view.layer.cornerRadius = 8
            view.layer.borderWidth = 1
            view.layer.borderColor = UIColor(named: "blue_primary")?.cgColor
            return view
        }()

        let btnContainerView: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()

        let btnWrapper: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = UIColor(named: "blue_primary")?.withAlphaComponent(0.2)
            view.layer.cornerRadius = 30
            return view
        }()

        let btn: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = UIColor(named: "blue_primary")
            view.layer.cornerRadius = 24
            return view
        }()

        let imageView: UIImageView = {
            let originalImage = UIImage(named: "user_with_linking")!
            let resizingFactor = 10 / originalImage.size.height
            let newImage = UIImage(cgImage: originalImage.cgImage!, scale: originalImage.scale / resizingFactor, orientation: .up)
            let imageView = UIImageView(image: newImage)
            imageView.translatesAutoresizingMaskIntoConstraints = false

            return imageView
        }()

        let textView: UITextView = {
            let textView = UITextView()
            textView.contentInsetAdjustmentBehavior = .automatic
            textView.textAlignment = NSTextAlignment.center
            textView.textColor = UIColor(named: "blue_primary")
            textView.text = "Initialise SDK with user linking"
            textView.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
            textView.translatesAutoresizingMaskIntoConstraints = false
            return textView
        }()

        contentView.addSubview(btnContainerView)

        btnWrapper.addSubview(btn)
        btn.addSubview(imageView)

        btnContainerView.addSubview(btnWrapper)
        btnContainerView.addSubview(textView)

        stackView.addArrangedSubview(contentView)

        let btnContainerViewConstraints = [
            btnContainerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            btnContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            btnContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            btnContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ]
        NSLayoutConstraint.activate(btnContainerViewConstraints)

        let btnWrapperConstraints = [
            btnWrapper.widthAnchor.constraint(equalToConstant: 60),
            btnWrapper.heightAnchor.constraint(equalToConstant: 60),
            btnWrapper.centerXAnchor.constraint(equalTo: btnContainerView.centerXAnchor),
            btnWrapper.topAnchor.constraint(equalTo: btnContainerView.topAnchor),
        ]

        NSLayoutConstraint.activate(btnWrapperConstraints)

        let btnConstraints = [
            btn.widthAnchor.constraint(equalToConstant: 48),
            btn.heightAnchor.constraint(equalToConstant: 48),
            btn.centerXAnchor.constraint(equalTo: btnWrapper.centerXAnchor),
            btn.centerYAnchor.constraint(equalTo: btnWrapper.centerYAnchor),
        ]

        NSLayoutConstraint.activate(btnConstraints)

        let imageViewConstraints = [
            imageView.widthAnchor.constraint(equalToConstant: 20),
            imageView.heightAnchor.constraint(equalToConstant: 10),
            imageView.centerXAnchor.constraint(equalTo: btn.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: btn.centerYAnchor),
        ]

        NSLayoutConstraint.activate(imageViewConstraints)

        let textViewConstraints = [
            textView.leadingAnchor.constraint(equalTo: btnContainerView.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: btnContainerView.trailingAnchor),
            textView.topAnchor.constraint(equalTo: btnWrapper.bottomAnchor, constant: 12),
            textView.heightAnchor.constraint(equalToConstant: 30),
        ]

        NSLayoutConstraint.activate(textViewConstraints)

        let contentViewConstraints = [
            contentView.heightAnchor.constraint(equalToConstant: 136),
            contentView.leadingAnchor.constraint(equalTo: stackView.layoutMarginsGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: stackView.layoutMarginsGuide.trailingAnchor),
        ]
        NSLayoutConstraint.activate(contentViewConstraints)

        return contentView
    }
}
