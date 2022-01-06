//
//  ViewController.swift
//  sample_app_ios
//
//  Created by Rameshwaran B on 2021-12-04.
//

import UIKit

class HomeViewController: UIViewController {
    
    @objc func handleInitWithoutLinkTap(sender: UITapGestureRecognizer) {
        Store.setBool(false, forKey: "SentianceUserLinkingEnabled")
        SdkHelper.callSdkSetup(false)

        let status = SdkStatusViewController()

        self.present(status, animated: true, completion: {
            print("Status view presented")
        })
    }

    @objc func handleInitWithLinkTap(sender: UITapGestureRecognizer) {
        Store.setBool(true, forKey: "SentianceUserLinkingEnabled")
        SdkHelper.callSdkSetup(true)

        let status = SdkStatusViewController()

        self.present(status, animated: true, completion: {
            print("Status view presented")
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "gray_lighter")
        
        let homeView =  HomeView()
        let headerView = addHeaderView()
        let contentView = homeView.addContentView(view, headerView: headerView)
        let stackView = homeView.addStackView(contentView)
        let emptyView = homeView.getEmptyView()
        let greetingTextView = homeView.getGreetingTextView()
        let initializationTextView = homeView.getinitializationTextView()
        
        stackView.addArrangedSubview(emptyView)
        stackView.addArrangedSubview(greetingTextView)
        stackView.addArrangedSubview(initializationTextView)

        let initWithLink = homeView.addInitWithLinkBtn(stackView)
        initWithLink.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleInitWithLinkTap(sender:))))

        let initWithoutLink = homeView.addInitWithoutLinkBtn(stackView)
        initWithoutLink.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleInitWithoutLinkTap(sender:))))
    }
}

