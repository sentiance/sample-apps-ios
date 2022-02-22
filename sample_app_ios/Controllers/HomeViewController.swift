//
//  ViewController.swift
//  sample_app_ios
//
//  Created by Rameshwaran B on 2021-12-04.
//

import SENTSDK
import UIKit

class HomeViewController: UIViewController {
    /// Start here!
    ///
    /// This handler is invoked when you tap on the "initialise SDK without user linking"
    /// It demostrates how to invoke the "createUser" method which starts detections
    /// You will also notice it first fetches the credentials from a backend service which
    /// is then used to initialise the SDK
    @objc func handleInitWithoutLinkTap(
        sender _: UITapGestureRecognizer
    ) {
        // DO NOT COPY THE NEXT LINE. This is for the functionality of this Sample application
        Store.setStr("DISABLED", forKey: "UserLinking")

        HttpHelper.fetchConfig {
            configResult in
            switch configResult {
            case let .success(config):
                SentianceHelper.createUser(SentianceHelper.SDKParams(
                    appId: config.id,
                    appSecret: config.secret,
                    baseUrl: "https://api.sentiance.com",
                    link: nil,
                    initCb: { issue in
                        // DO NOT COPY THE BODY OF THIS FUNCTION
                        //
                        // Include your app specific workflow you would like
                        // to be invoked on SDK initialization
                        DataModelHelper.initCallback(issue)

                        DispatchQueue.main.async { [self] in
                            self.present(
                                SdkStatusViewController(),
                                animated: true
                            )
                        }
                    }
                ))
            case let .failure(error):
                print("Error fetching config: \(error)")
            }
        }
    }

    /// Similar to the previous handler this is invoked when "initialise SDK wiith user linking"
    /// it tapped. It additioanlly demonstrates how to perform a user linking in the SDK integration.
    /// The workflow communicates with the provided sample backend service to perform
    /// the user linking.
    @objc func handleInitWithLinkTap(
        sender _: UITapGestureRecognizer
    ) {
        // DO NOT COPY THE NEXT LINE.
        // This is for the functionality of this Sample application
        Store.setStr("ENABLED", forKey: "UserLinking")

        let lintFn: MetaUserLinker =
            { installId, linkSuccess, linkFailed in
                Store.setStr(installId!, forKey: "SentianceInstallId")
                HttpHelper.linkUser(installId!, completion: {
                    linkResult in
                    switch linkResult {
                    case let .success(data):
                        linkSuccess!()
                        print(data)
                        DataModelHelper.set()
                    case let .failure(error):
                        linkFailed!()
                        print("Error while linking user: \(error)")
                    }
                })
            }

        HttpHelper.fetchConfig {
            configResult in
            switch configResult {
            case let .success(config):
                SentianceHelper.createUser(SentianceHelper.SDKParams(
                    appId: config.id,
                    appSecret: config.secret,
                    baseUrl: "https://api.sentiance.com",
                    link: lintFn,
                    initCb: { issue in
                        // DO NOT COPY THE BODY OF THIS FUNCTION
                        //
                        // Include your app specific workflow you would like
                        // to be invoked on SDK initialization

                        DataModelHelper.initCallback(issue)

                        DispatchQueue.main.async { [self] in
                            self.present(
                                SdkStatusViewController(),
                                animated: true
                            )
                        }
                    }
                ))
            case let .failure(error):
                print("Error while fetching config: \(error)")
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(named: "gray_lighter")

        let homeView = HomeView()
        let stackView = homeView.addStackView(
            view,
            headerView: addHeaderView()
        )

        homeView.addInitWithLinkBtn(stackView)
            .addGestureRecognizer(UITapGestureRecognizer(
                target: self,
                action: #selector(handleInitWithLinkTap(sender:))
            ))

        homeView.addInitWithoutLinkBtn(stackView)
            .addGestureRecognizer(
                UITapGestureRecognizer(
                    target: self,
                    action: #selector(
                        handleInitWithoutLinkTap(sender:)
                    )
                )
            )
    }
}
