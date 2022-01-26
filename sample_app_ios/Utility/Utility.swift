//
//  Utility.swift
//  sample_app_ios
//
//  Created by Rameshwaran B on 2021-12-11.
//

import UIKit

class Utility {
    static func getBgColor(_ status: DataModel.Status) -> UIColor? {
        switch status {
        case .success:
            return UIColor(named: "green_lightest_2")
        case .warn:
            return UIColor(named: "yellow_lightest_2")
        case .danger:
            return UIColor(named: "red_lightest_2")
        }
    }

    static func getDarkTextColor(_ status: DataModel.Status) -> UIColor? {
        switch status {
        case .success:
            return UIColor(named: "green_darker")
        case .warn:
            return UIColor(named: "yellow_default")
        case .danger:
            return UIColor(named: "red_dark")
        }
    }

    static func getTextColor(_ status: DataModel.Status) -> UIColor? {
        switch status {
        case .success:
            return UIColor(named: "green_default")
        case .warn:
            return UIColor(named: "yellow_default")
        case .danger:
            return UIColor(named: "red_default")
        }
    }
}
