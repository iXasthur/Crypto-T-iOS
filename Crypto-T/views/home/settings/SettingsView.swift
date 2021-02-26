//
//  SettingsView.swift
//  Crypto-T
//
//  Created by Михаил Ковалевский on 23.02.2021.
//

import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject var session: Session
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("General")) {
                    Section {
                        Button(action: {
                            session.destroy()
                        }) {
                            Text("Log Out")
                        }
                    }
                }
            }
            .navigationBarTitle("Settings")
        }
    }
}
