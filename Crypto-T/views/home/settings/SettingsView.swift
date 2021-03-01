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
                Section(header:
                            Text("language")
                ) {
                    Picker("123", selection: $session.settings.localization) {
                        Text("sys_lang")
                            .tag(UserLocale.system)
                        Text("en_lang")
                            .tag(UserLocale.en)
                        Text("ru_lang")
                            .tag(UserLocale.ru)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                Section(header: Text("general")) {
                    Section {
                        Button(action: {
                            session.destroy()
                        }) {
                            Text("log_out")
                        }
                    }
                }
            }
            .navigationBarTitle("settings", displayMode: .inline)
        }
    }
}
