//
//  ViewController.swift
//  sample_app_ios
//
//  Created by Rameshwaran B on 2021-12-04.
//

import UIKit

class HomeViewController: UIViewController {
    
    @objc func handleInitWithoutLinkTap(sender: UITapGestureRecognizer) {
        callSdkSetup(shouldLinkUser: false)

        let status = SdkStatusViewController()

        self.present(status, animated: true, completion: {
            print("Status view presented")
        })
    }

    @objc func handleInitWithLinkTap(sender: UITapGestureRecognizer) {
        callSdkSetup(shouldLinkUser: true)

        let status = SdkStatusViewController()

        self.present(status, animated: true, completion: {
            print("Status view presented")
        })
    }

    // callSdkSetup retrieves the app id and secret from the backend if it is not already stored in store
    // The app id and secret are retrieved to initialise the sdk
    func callSdkSetup (shouldLinkUser: Bool) {
        let appId = Store.getStr("SentianceAppId")
        let appSecret = Store.getStr("SentianceAppSecret")
        let baseUrl = "https://api.sentiance.com"
        var setupSdkConfig = SentianceHelper.SetupSDKConfig(shouldLinkUser: shouldLinkUser, appId: appId, appSecret: appSecret, baseUrl: baseUrl)

        if (appId == "" || appSecret == "") {
            HttpHelper.fetchConfig {
                (configResult) in
                switch configResult {
                case let .success(config):
                    setupSdkConfig.appId = config.id
                    setupSdkConfig.appSecret = config.secret
                    SentianceHelper.setupSdk(setupSdkConfig)
                case let .failure(error):
                    print("Error fetching config: \(error)")
                }
            }
        } else {
            SentianceHelper.setupSdk(setupSdkConfig)
        }
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

