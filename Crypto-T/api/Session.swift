//
//  Session.swift
//  Crypto-T
//
//  Created by Михаил Ковалевский on 24.02.2021.
//

import Foundation
import Firebase

class Session: ObservableObject {
    
    @Published private var authData: AuthData? = nil
    @Published private var dashboard: CryptoDashboard? = nil
    
    @Published var initialized: Bool = false
    
    func getLocalAssets() -> [CryptoAsset]? {
        return dashboard?.assets
    }
    
    func getLocalPlatforms() -> [CryptoPlatform]? {
        return dashboard?.platforms
    }
    
    private func addLocalAsset(_ asset: CryptoAsset) {
        dashboard?.assets.append(asset)
    }
    
    func createNewAsset(_ asset: CryptoAsset, completion: @escaping (Error?) -> Void) {
        // Add to firebase then to local
        addLocalAsset(asset)
        completion(nil)
    }
    
    func setupDashboard() {
        dashboard = CryptoDashboard()
    }
    
    private func initialize(_ authData: AuthData) -> Bool {
        self.authData = authData
        
        AuthDataStorage.saveToKeychain(authData)
        
        setupDashboard()
        
        initialized = true
        return initialized
    }
    
    func destroy() {
        initialized = false
        
        AuthDataStorage.deleteFromKeychain()
        
        do {
            try Firebase.Auth.auth().signOut()
        } catch {
            print(error)
        }
        authData = nil
        dashboard = nil
    }
    
    func restore(completion: @escaping (Error?) -> Void) -> AuthData? {
        if let authData = AuthDataStorage.restoreFromKeychain() {
            signInEmail(email: authData.email, password: authData.password) { (error) in
                self.handleFirebaseAuthResponse(authData: authData, error: error, completion: completion)
            }
            return authData
        } else {
            let error = NSError(
                domain: "",
                code: 0,
                userInfo: [
                    NSLocalizedDescriptionKey : "Unable to restore session"
                ])
            completion(error)
            return nil
        }
    }
    
    func signUpEmail(email: String, password: String, completion: @escaping (Error?) -> Void) {
        Firebase.Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            let authData = AuthData(email: email, password: password)
            self.handleFirebaseAuthResponse(authData: authData, error: error, completion: completion)
        }
    }
    
    func signInEmail(email: String, password: String, completion: @escaping (Error?) -> Void) {
        Firebase.Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            let authData = AuthData(email: email, password: password)
            self.handleFirebaseAuthResponse(authData: authData, error: error, completion: completion)
        }
    }
    
    func handleFirebaseAuthResponse(authData: AuthData, error: Error?, completion: @escaping (Error?) -> Void) {
        guard error == nil else {
            completion(error)
            return
        }
        if self.initialize(authData) {
            completion(nil)
        } else {
            let error = NSError(
                domain: "",
                code: 0,
                userInfo: [
                    NSLocalizedDescriptionKey : "Unable to initialize session"
                ])
            completion(error)
        }
    }
}
