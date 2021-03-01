//
//  SettingsData.swift
//  Crypto-T
//
//  Created by Михаил Ковалевский on 23.02.2021.
//

import Foundation


struct SettingsData: Codable {
    
    static let localeKey = "email"
    
    var localization = UserLocale.system {
        didSet {
            saveToDefaultUD()
        }
    }
    
    private func saveToDefaultUD() {
        UserDefaults.standard.setValue(localization.rawValue, forKey: SettingsData.localeKey)
    }
    
    static func restoreFromDefaultUD() -> SettingsData {
        if let code = UserDefaults.standard.string(forKey: SettingsData.localeKey),
           let locale = UserLocale.init(rawValue: code) {
            return SettingsData(localization: locale)
        } else {
            return SettingsData()
        }
    }
}
