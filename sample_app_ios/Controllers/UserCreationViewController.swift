//
//  ViewController.swift
//  sample_app_ios
//
//  Created by Rameshwaran B on 2021-12-04.
//

import SENTSDK
import UIKit

class UserCreationViewController: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        if (Sentiance.shared.userExists) {
            presentStatusViewController(animated: false)
        }
    }
    
    /// Start here.
    /// This handler is invoked when "Create User" is tapped.
    /// It additionally demonstrates how to create a linked sentiance user.
    /// The workflow communicates with the provided sample backend service to obtain authentication code.
    @IBAction func onCreateUser(_ sender: UIButton) {
        // Get auth code from your backend to create Sentiance SDK user
        // See https://github.com/sentiance/sample-apps-api
        AuthCodeAPI.getAuthCodeFromServer { authCode, error in
            if let authCode = authCode {
                self.createUserAndEnableDetections(authCode: authCode)
            }
            else {
                self.showMessage(message: error!)
                print(error!)
            }
        }
    }
    
    private func createUserAndEnableDetections(authCode: String) {
        let userCreationOptions = SENTUserCreationOptions(authenticationCode: authCode)
        Sentiance.shared.createUser(options: userCreationOptions) { result, error in
            guard let result = result else {
                let log = "createSentianceUser: failed with error: \(String(describing: error!.failureReason))"
                print(log)
                self.showMessage(message: log)
                return
            }

            let log = "User created successfully, userId: \(result.userInfo.userId)"
            print(log)
            self.enableDetections()
        }
    }
    
    private func enableDetections() {
        print("Enabling detections..")
        Sentiance.shared.enableDetections { result, error in
            guard let result = result else {
                let log = "enableDetections: failed with error: \(String(describing: error!.failureReason))"
                print(log)
                self.showMessage(message: log)
                return
            }

            let log = "Detections enabled successfully, detection status: \(result.detectionStatus)"
            print(log)
            self.presentStatusViewController(animated: true)
        }
    }
    
    private func presentStatusViewController(animated: Bool = true) {
        if let sdkStatusViewController = storyboard?.instantiateViewController(withIdentifier: "SdkStatusViewController") as? SdkStatusViewController {
            sdkStatusViewController.isModalInPresentation = false
            navigationController?.pushViewController(sdkStatusViewController, animated: animated)
        }
    }
}
