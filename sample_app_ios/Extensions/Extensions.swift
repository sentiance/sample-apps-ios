//
//  HeaderView.swift
//  sample_app_ios
//
//  Created by Rameshwaran B on 2021-12-12.
//

import SPPermissions
import UIKit


extension SPPermissionsListController {
    public override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
        super.viewWillAppear(animated)
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
        super.viewWillDisappear(animated)
    }
}

extension UIViewController {
    func showMessage(message : String, seconds: Double = 2){
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.view.backgroundColor = .black
        alert.view.alpha = 0.5
        alert.view.layer.cornerRadius = 15
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            alert.dismiss(animated: true)
        }
    }
}
