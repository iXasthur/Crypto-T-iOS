//
//  GoogleMapsLocationPickerView.swift
//  Crypto-T
//
//  Created by Михаил Ковалевский on 01.03.2021.
//

import SwiftUI
import GoogleMaps

struct GoogleMapsLocationPickerView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var latitude: Double?
    @Binding var longitude: Double?
    
    let assistant: GoogleMapsAssistant = GoogleMapsAssistant()
    
    var body: some View {
        NavigationView {
            ZStack {
                GoogleMapsView(assistant: assistant, showCryptoEventPins: false)
                    .edgesIgnoringSafeArea(.all)
                    .navigationBarTitle("pick_location", displayMode: .inline)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("back") {
                                presentationMode.wrappedValue.dismiss()
                            }
                        }
                        
                        ToolbarItem(placement: .confirmationAction) {
                            Button("select") {
                                latitude = assistant.position?.latitude
                                longitude = assistant.position?.longitude
                                presentationMode.wrappedValue.dismiss()
                            }
                        }
                    }
                Image(systemName: "mappin")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(Color.accentColor)
                    .frame(height: 20)
                    .padding(.bottom, 20)
            }
        }
    }
}
