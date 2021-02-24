//
//  CryptoTApp.swift
//  Crypto-T
//
//  Created by Михаил Ковалевский on 23.02.2021.
//

import SwiftUI
import Firebase

@main
struct CryptoTApp: App {
    
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    
    @StateObject var dashboard = Dashboard()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(dashboard)
        }
    }
    
    class AppDelegate: NSObject, UIApplicationDelegate {
        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
          FirebaseApp.configure()
          return true
        }
      }
    
}
