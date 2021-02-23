//
//  CryptoTApp.swift
//  Crypto-T
//
//  Created by Михаил Ковалевский on 23.02.2021.
//

import SwiftUI

@main
struct CryptoTApp: App {
    
    @StateObject var dashboard = Dashboard()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(dashboard)
        }
    }
}
