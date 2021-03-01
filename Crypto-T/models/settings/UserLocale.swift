//
//  UserLocale.swift
//  Crypto-T
//
//  Created by Михаил Ковалевский on 01.03.2021.
//

import Foundation

enum UserLocale: String, Identifiable, Codable {
    static let available: [UserLocale] = [.system, .en, .ru]
    
    var id: String {
        return self.rawValue
    }
    
    var languageCode: String {
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
    
    case system = "sys_lang"
    case en = "en_lang"
    case ru = "ru_lang"
}
