//
//  SettingsData.swift
//  Crypto-T
//
//  Created by Михаил Ковалевский on 23.02.2021.
//

import Foundation


struct SettingsData: Codable {
    static func save() {
        // Save to local storage
    }
    
    static func restore() -> SettingsData {
        return SettingsData()
    }
}
