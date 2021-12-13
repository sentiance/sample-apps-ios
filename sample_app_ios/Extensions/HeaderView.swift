//
//  HeaderView.swift
//  sample_app_ios
//
//  Created by Rameshwaran B on 2021-12-12.
//

import UIKit
import SPPermissions

extension UIViewController {
    func addHeaderView () -> UIView {
        let headerView: UIView = {
            let headerView = UIView()
            headerView.backgroundColor = .black
            headerView.translatesAutoresizingMaskIntoConstraints = false
            return headerView
        }()
        
        let emptyView: UIView = {
            let view = UIView()
            view.backgroundColor = .black
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        let imageView: UIImageView = {
            let originalImage = UIImage(named: "sentiance_logo_white")!
            let resizingFactor = 100 / originalImage.size.height
            let newImage = UIImage(cgImage: originalImage.cgImage!, scale: originalImage.scale / resizingFactor, orientation: .up)
            let imageView = UIImageView(image: newImage)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            
            return imageView
        }()
        
        view.addSubview(emptyView)
        view.addSubview(headerView)
        headerView.addSubview(imageView)
        
        let emptyViewConstraints =  [
            emptyView.topAnchor.constraint(equalTo: view.topAnchor),
            emptyView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            emptyView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            emptyView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ]
        NSLayoutConstraint.activate(emptyViewConstraints)
        
        let headerConstraints =  [
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 80),
            headerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ]
        NSLayoutConstraint.activate(headerConstraints)

        let imageConstraints = [
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
        ]
        NSLayoutConstraint.activate(imageConstraints)
        
        return headerView
    }
}

