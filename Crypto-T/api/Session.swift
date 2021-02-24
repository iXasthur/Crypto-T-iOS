//
//  Session.swift
//  Crypto-T
//
//  Created by Михаил Ковалевский on 24.02.2021.
//

import Foundation


class Session: ObservableObject {
    
    @Published var authData: AuthData? = nil
    @Published var dashboard: CryptoDashboard? = nil
    
    @Published var initialized: Bool = false
    
    func initialize(_ authData: AuthData) {
        initialized = false
    }
    
    func destroy() {
        initialized = false
        
        authData = nil
        dashboard = nil
    }
}

// Firebase calls
extension Session {
    
}
