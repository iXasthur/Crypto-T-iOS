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
                    Label("cryptos", systemImage: "cube")
                }
            
            MapView()
                .tabItem {
                    Label("map", systemImage: "map")
                }
            
            SettingsView()
                .tabItem {
                    Label("settings", systemImage: "gearshape")
                }
        }
    }
}
