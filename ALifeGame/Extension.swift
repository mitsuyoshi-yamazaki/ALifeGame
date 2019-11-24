//
//  Extension.swift
//  ALifeGame
//
//  Created by Yamazaki Mitsuyoshi on 2019/11/24.
//  Copyright © 2019 Yamazaki Mitsuyoshi. All rights reserved.
//

import Foundation

extension Bundle {
    var version: String {
        guard let version = object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String else {
            return ""
        }
        return version
    }

    var buildNumber: String {
        guard let version = object(forInfoDictionaryKey: "CFBundleVersion") as? String else {
            return ""
        }
        return version
    }

    var versionFullString: String {
        return "\(version) (\(buildNumber))"
    }
}
