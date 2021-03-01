//
//  SettingsView.swift
//  Crypto-T
//
//  Created by Михаил Ковалевский on 23.02.2021.
//

import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject var session: Session
    
    @State var selectedLanguage: UserLocale = .system
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Language")) {
                    Picker("", selection: $selectedLanguage) {
                        ForEach(UserLocale.available) { loc in
                            Text(loc.rawValue)
                                .tag(loc)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .onChange(of: selectedLanguage) { (l) in
                        session.settings.setLocalization(l)
                    }
                }
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
            .navigationBarTitle("Settings", displayMode: .inline)
        }
    }
}
