//
//  CryptoEditorView.swift
//  Crypto-T
//
//  Created by Михаил Ковалевский on 28.02.2021.
//

import SwiftUI
import URLImage
import AVKit


enum CryptoEditorViewSheet: Identifiable {
    case image, video
    
    var id: Int {
        hashValue
    }
}

struct CryptoEditorView: View {
    
    let title = "Edit crypto"
    let descriptionPlaceholderString = "Description"
    
    @EnvironmentObject var session: Session
    
    @Binding var isPresented: Bool
    
    @State var activeSheet: CryptoEditorViewSheet? = nil
    
    @State var progress: Bool = false
    
    @State var name: String
    @State var code: String
    @State var description: String
    
    @State var iconNsUrl: NSURL?
    @State var videoNsUrl: NSURL?
    
    let assetToEdit: CryptoAsset
    
    
    init(assetToEdit: CryptoAsset, isPresented: Binding<Bool>) {
        self._isPresented = isPresented
        self.assetToEdit = assetToEdit
        self._name = State(initialValue: assetToEdit.name)
        self._code = State(initialValue: assetToEdit.code)
        self._description = State(initialValue: assetToEdit.description)
        
        if let iconFileData = assetToEdit.iconFileData {
            self._iconNsUrl = State(initialValue: NSURL(string: iconFileData.downloadURL))
        }
        
        if let videoFileData = assetToEdit.videoFileData {
            self._videoNsUrl = State(initialValue: NSURL(string: videoFileData.downloadURL))
        }
    }
    
    func validateEditedAsset() -> Bool {
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
                                
                                if let iconURL = iconNsUrl?.absoluteURL {
                                    URLImage(url: iconURL) { image in
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 60, height: 60)
                                            .clipShape(Circle())
                                            .overlay(Circle().stroke(Color.secondary, lineWidth: 2))
                                            .padding(.all, 10)
                                    }
                                }
                            }
                        }
                        
                        if iconNsUrl != nil {
                            Button {
                                withAnimation {
                                    iconNsUrl = nil
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
                            }
                        }
                        
                        if let url = videoNsUrl?.absoluteURL {
                            let videoPlayer: AVPlayer = AVPlayer(url: url)
                            
                            VideoPlayer(player: videoPlayer)
                                .aspectRatio(16.0/9.0, contentMode: .fit)
                            
                            Button {
                                videoPlayer.pause()
                                videoPlayer.replaceCurrentItem(with: nil)
                                
                                withAnimation {
                                    videoNsUrl = nil
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
                }
                .navigationBarTitle(title, displayMode: .inline)
                .sheet(item: $activeSheet) { item in
                    switch item {
                    case .image:
                        ImagePickerView(imageNSURL: $iconNsUrl)
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
                            withAnimation {
                                progress = true
                            }

                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                let asset = CryptoAsset(id: assetToEdit.id, name: name, code: code, description: description)

                                session.updateRemoteAsset(asset: asset, iconNSURL: iconNsUrl, videoNSURL: videoNsUrl) { (error) in
                                    progress = false

                                    if error == nil {
                                        isPresented.toggle()
                                    }
                                }
                            }
                        }
                        .disabled(!validateEditedAsset())
                    }
                }
                
                if progress {
                    ProgressView()
                }
            }
        }
        .allowsHitTesting(!progress)
    }
}
