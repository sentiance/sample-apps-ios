//
//  Store.swift
//  sample_app_ios
//
//  Created by Rameshwaran B on 2021-12-18.
//

import Foundation

class Store {
    static func setStr(_ value: String, forKey: String) {
        UserDefaults.standard.set(value, forKey: forKey)
    }

    static func getStr(_ forKey: String) -> String {
        if let data = UserDefaults.standard.string(forKey: forKey) {
            return data
        }
        return ""
    }

    static func setBool(_ value: Bool, forKey: String) {
        UserDefaults.standard.set(value, forKey: forKey)
    }

    static func getBool(_ key: String) -> Bool {
        return UserDefaults.standard.bool(forKey: key)
    }
}
