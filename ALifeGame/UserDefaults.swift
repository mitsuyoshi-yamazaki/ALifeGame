//
//  UserDefaults.swift
//  ALifeGame
//
//  Created by Yamazaki Mitsuyoshi on 2019/11/24.
//  Copyright © 2019 Yamazaki Mitsuyoshi. All rights reserved.
//

import Foundation

extension UserDefaults {
    func logCurrentContent() {
        guard let bundleID = Bundle.main.bundleIdentifier else {
            print(dictionaryRepresentation())
            return
        }

        let applicationContents = dictionaryRepresentation()
            .filter { key, _ in
                key.contains(bundleID)
            }
        print(applicationContents)
    }
}

extension UserDefaults {
    enum Key: String {
        case onboardingFinishVersion
    }

    var anyOnboardingFinished: Bool {
        get {
            let list = onboardingFinishList()
            return list.isEmpty == false
        }
        set {
            var list = onboardingFinishList()
            list[Onboarding.current.rawValue] = Date()

            let key = fullKey(.onboardingFinishVersion)
            UserDefaults.standard.set(list, forKey: key)
        }
    }

    func onboardingFinishList() -> [String: Date] { // [Onboarding.rawValue: Date]
        let key = fullKey(.onboardingFinishVersion)
        guard let list = UserDefaults.standard.object(forKey: key) as? [String: Date] else {
            return [:]
        }
        return list
    }
}

extension UserDefaults {
    private func fullKey(_ key: Key) -> String {
        let bundleID = Bundle.main.bundleIdentifier ?? ""
        return "\(bundleID).\(key.rawValue)"
    }
}

enum Onboarding: String {
    case corkboard

    static var current = Onboarding.corkboard
}
