//
//  CryptoTApp.swift
//  Crypto-T
//
//  Created by Михаил Ковалевский on 23.02.2021.
//

import SwiftUI
import Firebase
import GoogleMaps

@main
struct CryptoTApp: App {
    
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    
    @StateObject var session = Session()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(session)
                .onAppear {
                    
                }
        }
    }
    
    class AppDelegate: NSObject, UIApplicationDelegate {
        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//            UIScrollView.appearance().keyboardDismissMode = .onDrag
            
            if let path = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist"),
               let nsDictionary = NSDictionary(contentsOfFile: path),
               let API_KEY = nsDictionary["API_KEY"] as? String {
                GMSServices.provideAPIKey(API_KEY)
            } else {
                fatalError()
            }
            
            FirebaseApp.configure()
            return true
        }
    }
    
}
