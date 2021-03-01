//
//  MapView.swift
//  Crypto-T
//
//  Created by Михаил Ковалевский on 23.02.2021.
//

import SwiftUI

struct MapView: View {
    
    @State var assistant: GoogleMapsAssistant = GoogleMapsAssistant()
    
    var body: some View {
        NavigationView {
            GoogleMapsView(assistant: $assistant)
                .edgesIgnoringSafeArea(.all)
                .navigationBarTitle("Map", displayMode: .inline)
        }
    }
}
