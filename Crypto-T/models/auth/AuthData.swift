//
//  AuthData.swift
//  Crypto-T
//
//  Created by Михаил Ковалевский on 23.02.2021.
//

import Foundation


struct AuthData: Codable {
    
    func save() {
        // Save to local storage
    }
    
    static func restore() -> AuthData? {
        return nil
    }
    
}
