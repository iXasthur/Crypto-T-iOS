//
//  UserLocale.swift
//  Crypto-T
//
//  Created by Михаил Ковалевский on 01.03.2021.
//

import Foundation

enum UserLocale: String, Identifiable, Codable {
    var id: String {
        return self.rawValue
    }
    
    var languageCode: String {
        print(self)
        switch self {
        case .system:
            if let systemLanguageCode: String = Locale.current.languageCode {
                return systemLanguageCode
            } else {
                return "en"
            }
        case .en:
            return "en"
        case .ru:
            return "ru"
        }
    }
    
    case system = "sys_lang_e"
    case en = "en_lang_e"
    case ru = "ru_lang_e"
}
