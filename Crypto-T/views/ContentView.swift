//
//  ContentView.swift
//  Crypto-T
//
//  Created by Михаил Ковалевский on 23.02.2021.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var session: Session
    
    var body: some View {
        AuthView()
            .fullScreenCover(
                isPresented: $session.initialized
            ) {
                HomeView()
                    .environmentObject(session)
                    .environment(\.locale, Locale(identifier: session.settings.localization.languageCode))
            }
    }
}
