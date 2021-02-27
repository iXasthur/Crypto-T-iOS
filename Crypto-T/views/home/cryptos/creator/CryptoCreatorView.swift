//
//  CryptoCreatorView.swift
//  Crypto-T
//
//  Created by Михаил Ковалевский on 26.02.2021.
//

import SwiftUI

struct CryptoCreatorView: View {
    
    let title = "New crypto"
    let descriptionPlaceholderString = "Description"
    
    @EnvironmentObject var session: Session
    
    @Binding var isPresented: Bool
    
    @State var progress: Bool = false
    
    @State var name: String = ""
    @State var code: String = ""
    @State var description: String = ""
    
    var iconURL: String? = nil
    var promoVideoURL: String? = nil
    
    func validateNewAsset() -> Bool {
        if (
            name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
            code.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
            description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        ) {
            return false
        }
        
        return true
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Form {
                    Section(
                        header: Text("GENERAL").padding(.top)
                    ) {
                        TextField("Name", text: $name)
                            .disableAutocorrection(true)
                            .autocapitalization(.words)
                        TextField("Code", text: $code)
                            .disableAutocorrection(true)
                            .autocapitalization(.allCharacters)
                        ZStack(alignment: .topLeading) {
                            if description.isEmpty {
                                Text(descriptionPlaceholderString)
                                    .foregroundColor(Color(UIColor.placeholderText))
                                    .padding(.top, 8)
                            }
                            TextEditor(text: $description).padding(.leading, -4)
                        }
                    }
                    
                    Section(
                        header: Text("EXTRA")
                    ) {
                        Text("Icon")
                        Text("Video")
                    }
                }
                .navigationBarTitle(title, displayMode: .inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Back") {
                            isPresented.toggle()
                        }
                    }
                    
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Save") {
                            let asset = CryptoAsset(name: name, code: code, description: description)
                            
                            withAnimation {
                                progress = true
                            }
                            
                            session.updateRemoteAsset(asset) { (error) in
                                progress = false
                                
                                if error == nil {
                                    isPresented.toggle()
                                }
                            }
                        }
                        .disabled(!validateNewAsset())
                    }
                }
                
                if progress {
                    ProgressView()
                }
            }
        }
    }
}
