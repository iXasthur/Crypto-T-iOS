//
//  AuthDataStorage.swift
//  Crypto-T
//
//  Created by Михаил Ковалевский on 25.02.2021.
//

import Foundation
import SwiftKeychainWrapper


class AuthDataStorage {
    
    static let emailKey = "email"
    static let passwordKey = "password"
    
    static func saveToKeychain(_ authData: AuthData) {
        KeychainWrapper.standard.set(authData.email, forKey: emailKey)
        KeychainWrapper.standard.set(authData.password, forKey: passwordKey)
    }
    
    static func deleteFromKeychain() {
        KeychainWrapper.standard.removeObject(forKey: emailKey)
        KeychainWrapper.standard.removeObject(forKey: passwordKey)
    }
    
    static func restoreFromKeychain() -> AuthData? {
        if let email = KeychainWrapper.standard.string(forKey: emailKey) {
            if let password = KeychainWrapper.standard.string(forKey: passwordKey) {
                return AuthData(email: email, password: password)
            }
        }
        return nil
    }
}
