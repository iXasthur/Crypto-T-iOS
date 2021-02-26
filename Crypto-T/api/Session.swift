//
//  Session.swift
//  Crypto-T
//
//  Created by Михаил Ковалевский on 24.02.2021.
//

import Foundation
import Firebase

class Session: ObservableObject {
    
    let assetsCollectionFirebaseTag = "assets"
    
    @Published private var authData: AuthData? = nil
    @Published private var dashboard: CryptoDashboard? = nil
    
    @Published var initialized: Bool = false
    
    private var db = Firebase.Firestore.firestore()
    
    
    func getLocalAssets() -> [CryptoAsset]? {
        return dashboard?.assets
    }
    
    func getLocalPlatforms() -> [CryptoPlatform]? {
        return dashboard?.platforms
    }
    
    private func addLocalAsset(_ asset: CryptoAsset) {
        dashboard?.assets.append(asset)
    }
    
    private func addRemoteAsset(_ asset: CryptoAsset, completion: @escaping (Error?) -> Void) {
        let encoder = JSONEncoder()
        
        do {
            let data = try encoder.encode(asset)
            if var json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                json.removeValue(forKey: "id")
                
                let document = db.collection(assetsCollectionFirebaseTag).document(asset.id)
                document.setData(json) { error in
                    if let error = error {
                        print("Error writing document: \(error)")
                        completion(error)
                    } else {
                        print("Document successfully written!")
                        completion(nil)
                    }
                }
            } else {
                let error = NSError(
                    domain: "",
                    code: 0,
                    userInfo: [
                        NSLocalizedDescriptionKey : "Unable to create json object"
                    ])
                completion(error)
            }
        } catch {
            let error = NSError(
                domain: "",
                code: 0,
                userInfo: [
                    NSLocalizedDescriptionKey : "Unable to encode crypto asset"
                ])
            completion(error)
        }
    }
    
    func createNewAsset(_ asset: CryptoAsset, completion: @escaping (Error?) -> Void) {
        addRemoteAsset(asset) { (error) in
            if let error = error {
                print(error)
                completion(error)
            } else {
                self.addLocalAsset(asset)
                completion(nil)
            }
        }
    }
    
    private func getRemoteAssets(completion: @escaping ([CryptoAsset]?, Error?) -> Void) {
        db.collection(assetsCollectionFirebaseTag).getDocuments { (query, error) in
            if let error = error {
                completion(nil, error)
            } else if let query = query {
                var assets: [CryptoAsset] = []
                
                query.documents.forEach { (document) in
                    let decoder = JSONDecoder()
                    do {
                        var jsonData = document.data()
                        jsonData.updateValue(document.documentID, forKey: "id")
                        
                        if let data = try? JSONSerialization.data(withJSONObject: jsonData) {
                            var asset = try decoder.decode(CryptoAsset.self, from: data)
                            asset.id = document.documentID
                            assets.append(asset)
                        } else {
                            print("Can't create json data from firebase document data")
                        }
                    } catch {
                        print(error)
                    }
                }
                
                completion(assets, nil)
            } else {
                completion(nil, nil)
            }
        }
    }
    
    func updateDashboard(onCompleted: @escaping () -> Void) {
        getRemoteAssets { (assets, error) in
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
        
        updateDashboard {
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
        
        initialize(authData) {
            if self.initialized {
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
}
