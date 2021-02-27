//
//  CryptoCreatorView.swift
//  Crypto-T
//
//  Created by Михаил Ковалевский on 26.02.2021.
//

import SwiftUI


enum CryptoCreatorViewSheet: Identifiable {
    case image, video
    
    var id: Int {
        hashValue
    }
}

struct CryptoCreatorView: View {
    
    let title = "New crypto"
    let descriptionPlaceholderString = "Description"
    
    @EnvironmentObject var session: Session
    
    @Binding var isPresented: Bool
    
    @State var activeSheet: CryptoCreatorViewSheet? = nil
    
    @State var progress: Bool = false
    
    @State var name: String = ""
    @State var code: String = ""
    @State var description: String = ""
    @State var iconUiImage: UIImage? = nil
    @State var videoNsUrl: NSURL? = nil
    
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
                        header: Text("ICON")
                    ) {
                        Button {
                            activeSheet = .image
                        } label: {
                            HStack {
                                Text("Select")
                                Spacer()
                                
                                if let iconUiImage = iconUiImage {
                                    Image(uiImage: iconUiImage)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 30, height: 30)
                                        .clipShape(Circle())
                                        .overlay(Circle().stroke(Color.secondary, lineWidth: 2))
                                }
                            }
                        }
                        
                        if iconUiImage != nil {
                            Button {
                                withAnimation {
                                    iconUiImage = nil
                                }
                            } label: {
                                HStack {
                                    Text("Remove")
                                    Spacer()
                                }
                                .foregroundColor(.red)
                            }
                        }
                    }
                    
                    Section(
                        header: Text("VIDEO")
                    ) {
                        Button {
                            activeSheet = .video
                        } label: {
                            HStack {
                                Text("Select")
                                Spacer()
                                
                                if let videoNsUrl = videoNsUrl {
                                    Text(videoNsUrl.absoluteString!)
                                }
                            }
                        }
                    }
                }
                .navigationBarTitle(title, displayMode: .inline)
                .sheet(item: $activeSheet) { item in
                    switch item {
                    case .image:
                        ImagePickerView(cropToSquare: true, uiImage: $iconUiImage)
                    case .video:
                        VideoPickerView(videoNSURL: $videoNsUrl)
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Back") {
                            isPresented.toggle()
                        }
                    }
                    
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Save") {
                            let asset = CryptoAsset(id: UUID().uuidString, name: name, code: code, description: description)
                            
                            withAnimation {
                                progress = true
                            }
                            
                            session.updateRemoteAsset(asset: asset, image: iconUiImage) { (error) in
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
