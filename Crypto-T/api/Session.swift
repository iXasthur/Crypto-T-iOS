//
//  Session.swift
//  Crypto-T
//
//  Created by Михаил Ковалевский on 24.02.2021.
//

import Foundation
import Firebase

class Session: ObservableObject {
    
    @Published var authData: AuthData? = nil
    @Published var dashboard: CryptoDashboard? = nil
    
    @Published var initialized: Bool = false
    
    private func initialize(_ authData: AuthData) -> Bool {
        self.authData = authData
        
        initialized = true
        return initialized
    }
    
    func destroy() {
        initialized = false
        
        do {
            try Firebase.Auth.auth().signOut()
        } catch {
            print(error)
        }
        authData = nil
        dashboard = nil
    }
}

// Firebase calls
extension Session {
    func signUpEmail(email: String, password: String, completion: @escaping (Error?) -> Void) {
        Firebase.Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            guard error == nil else {
                completion(error)
                return
            }
            if self.initialize(AuthData(email: email, password: password)) {
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
    
    func signInEmail(email: String, password: String, completion: @escaping (Error?) -> Void) {
        Firebase.Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            guard error == nil else {
                completion(error)
                return
            }
            if self.initialize(AuthData(email: email, password: password)) {
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
