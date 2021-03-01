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
    
    @State var assistant: GoogleMapsAssistant = GoogleMapsAssistant()
    
    var body: some View {
        NavigationView {
            ZStack {
                GoogleMapsView(assistant: $assistant)
                    .edgesIgnoringSafeArea(.all)
                    .navigationBarTitle("Pick Location", displayMode: .inline)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Back") {
                                presentationMode.wrappedValue.dismiss()
                            }
                        }
                        
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Select") {
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
                    .frame(width: 20, height: 20)
                    .padding(.bottom, 10)
            }
        }
    }
}
