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
            NetworksListView()
                .tabItem {
                    Label("List", systemImage: "cube")
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
