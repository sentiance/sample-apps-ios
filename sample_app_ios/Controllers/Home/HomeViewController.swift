//
//  ViewController.swift
//  sample_app_ios
//
//  Created by Rameshwaran B on 2021-12-04.
//

import UIKit

class HomeViewController: UIViewController {
    
    @objc func handleNoLinkTap(sender: UITapGestureRecognizer) {
        SentianceHelper.initSdk()
        SentianceHelper.setupSdk()

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
        
        
        let _ = homeView.addInitWithLinkBtn(stackView)
        let noLinkContentView = homeView.addInitWithoutLinkBtn(stackView)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleNoLinkTap(sender:)))
        noLinkContentView.addGestureRecognizer(tapGesture)
    }
}

