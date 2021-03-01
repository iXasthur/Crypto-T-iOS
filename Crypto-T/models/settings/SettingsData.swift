//
//  SettingsData.swift
//  Crypto-T
//
//  Created by Михаил Ковалевский on 23.02.2021.
//

import Foundation


struct SettingsData: Codable {
    
    private var localization = UserLocale.system
    
    func setLocalization(_ loc: UserLocale) {
        switch loc {
        case .system:
            break
        case .en:
            break
        case .ru:
            break
        }
    }
    
    static func restore() -> SettingsData {
        return SettingsData()
    }
    
}
