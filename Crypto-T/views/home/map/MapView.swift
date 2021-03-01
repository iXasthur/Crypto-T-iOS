//
//  MapView.swift
//  Crypto-T
//
//  Created by Михаил Ковалевский on 23.02.2021.
//

import SwiftUI

struct MapView: View {
    
    let assistant: GoogleMapsAssistant = GoogleMapsAssistant()
    
    var body: some View {
        NavigationView {
            GoogleMapsView(assistant: assistant, showCryptoEventPins: true)
                .edgesIgnoringSafeArea(.all)
                .navigationBarTitle("Map", displayMode: .inline)
        }
    }
}
