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
    
    case system = "System"
    case en = "English"
    case ru = "Russian"
}
