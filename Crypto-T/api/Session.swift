//
//  Session.swift
//  Crypto-T
//
//  Created by Михаил Ковалевский on 24.02.2021.
//

import Foundation
import Firebase

class Session: ObservableObject {
    
    @Published var settings: SettingsData = SettingsData.restoreFromDefaultUD()
    @Published private var authData: AuthData? = nil
    @Published private var dashboard: CryptoDashboard? = nil
    
    @Published var initialized: Bool = false
    
    private let cryptoAssetManager = CryptoAssetFirebaseManager()
    
    
    func getLocalAssets() -> [CryptoAsset]? {
        return dashboard?.assets
    }
    
    func getLocalAsset(id: String) -> CryptoAsset? {
        return getLocalAssets()?.first(where: { (asset) -> Bool in
            asset.id == id
        })
    }
    
    private func deleteLocalAsset(asset: CryptoAsset) {
        if let index = getLocalAssets()?.firstIndex(where: { (a) -> Bool in
            a.id == asset.id
        }) {
            dashboard?.assets.remove(at: index)
        }
    }
    
    func deleteRemoteAsset(asset: CryptoAsset, completion: @escaping (Error?) -> Void) {
        cryptoAssetManager.deleteRemoteAsset(asset) { (error) in
            if let error = error {
                print(error)
                completion(error)
            } else {
                self.deleteLocalAsset(asset: asset)
                completion(nil)
            }
        }
    }
    
    private func updateLocalAsset(_ asset: CryptoAsset) {
        if let index = dashboard?.assets.firstIndex(where: { (a) -> Bool in
            a.id == asset.id
        }) {
            dashboard?.assets[index] = asset
        } else {
            dashboard?.assets.append(asset)
        }
    }
    
    func updateRemoteAsset(asset: CryptoAsset, iconNSURL: NSURL?, videoNSURL: NSURL?, completion: @escaping (Error?) -> Void) {
        cryptoAssetManager.updateRemoteAsset(asset, iconNSURL, videoNSURL) { (updatedAsset, error) in
            if let error = error {
                print(error)
                completion(error)
            } else if let updatedAsset = updatedAsset {
                self.updateLocalAsset(updatedAsset)
                completion(nil)
            } else {
                let error = NSError.withLocalizedDescription("Invalid updateRemoteAsset form CryptoAssetFirebaseManager closure return")
                completion(error)
            }
        }
    }
    
    func syncDashboard(onCompleted: @escaping () -> Void) {
        cryptoAssetManager.getRemoteAssets { (assets, error) in
            if let error = error {
                print(error)
                self.dashboard?.assets = []
            } else if let assets = assets {
                self.dashboard?.assets = assets
            } else {
                print("Didn't receive assets and error")
                self.dashboard?.assets = []
            }            
            onCompleted()
        }
    }
    
    private func initialize(_ authData: AuthData, onCompleted: @escaping () -> Void) {
        self.authData = authData
        
        AuthDataStorage.saveToKeychain(authData)
        
        dashboard = CryptoDashboard()
        
        syncDashboard {
            self.initialized = true
            onCompleted()
        }
        
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
            let error = NSError.withLocalizedDescription("Unable to restore session")
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
    
    private func handleFirebaseAuthResponse(authData: AuthData, error: Error?, completion: @escaping (Error?) -> Void) {
        guard error == nil else {
            completion(error)
            return
        }
        
        initialize(authData) {
            if self.initialized {
                completion(nil)
            } else {
                let error = NSError.withLocalizedDescription("Unable to initialize session")
                completion(error)
            }
        }
    }
}
