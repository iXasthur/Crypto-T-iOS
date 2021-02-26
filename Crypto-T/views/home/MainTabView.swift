//
//  MainTabView.swift
//  Crypto-T
//
//  Created by Михаил Ковалевский on 23.02.2021.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            CryptosListView()
                .tabItem {
                    Label("Cryptos", systemImage: "cube")
                }
            
            MapView()
                .tabItem {
                    Label("Map", systemImage: "map")
                }
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
        }
    }
}
