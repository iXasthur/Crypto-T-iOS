//
//  SettingsData.swift
//  Crypto-T
//
//  Created by Михаил Ковалевский on 23.02.2021.
//

import Foundation


struct SettingsData: Codable {
    
    var localization = UserLocale.system
    
    func setLocalization(_ loc: UserLocale) {
        print(loc)
    }
    
}
