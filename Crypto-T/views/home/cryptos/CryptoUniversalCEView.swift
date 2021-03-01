//
//  CryptoUniversalCEView.swift
//  Crypto-T
//
//  Created by Михаил Ковалевский on 01.03.2021.
//

import SwiftUI
import URLImage
import AVKit


enum CryptoUniversalCEViewSheet: Identifiable {
    case image, video, map
    
    var id: Int {
        hashValue
    }
}

struct CryptoUniversalCEView: View {
    
    let creatorTitle = "new_crypto"
    let editorTitle = "edit_crypto"
    let descriptionPlaceholderString = "description"
    let notePlaceholderString = "note"
    
    let title: String
    
    @EnvironmentObject var session: Session
    
    @Binding var isPresented: Bool
    
    @State var activeSheet: CryptoUniversalCEViewSheet? = nil
    
    @State var progress: Bool = false
    
    @State var name: String
    @State var code: String
    @State var description: String
    
    @State var iconNsUrl: NSURL?
    @State var videoNsUrl: NSURL?
    
    @State var eventNote: String
    @State var eventLatitude: Double?
    @State var eventLongitude: Double?
    
    let assetToEdit: CryptoAsset?
    let additionalOnDeleteAction: (() -> Void)?
    
    // Init as creator
    init(isPresented: Binding<Bool>) {
        self._isPresented = isPresented
        self.title = creatorTitle
        self.assetToEdit = nil
        self.additionalOnDeleteAction = nil
        
        self._name = State(initialValue: "")
        self._code = State(initialValue: "")
        self._description = State(initialValue: "")
        self._iconNsUrl = State(initialValue: nil)
        self._videoNsUrl = State(initialValue: nil)
        
        self._eventNote = State(initialValue: "")
        self._eventLatitude = State(initialValue: nil)
        self._eventLongitude = State(initialValue: nil)
    }
    
    // Init as editor
    init(assetToEdit: CryptoAsset, onDelete: @escaping () -> Void, isPresented: Binding<Bool>) {
        self._isPresented = isPresented
        self.title = editorTitle
        self.assetToEdit = assetToEdit
        self.additionalOnDeleteAction = onDelete
        
        self._name = State(initialValue: assetToEdit.name)
        self._code = State(initialValue: assetToEdit.code)
        self._description = State(initialValue: assetToEdit.description)
        
        if let iconFileData = assetToEdit.iconFileData {
            self._iconNsUrl = State(initialValue: NSURL(string: iconFileData.downloadURL))
        } else {
            self._iconNsUrl = State(initialValue: nil)
        }
        
        if let videoFileData = assetToEdit.videoFileData {
            self._videoNsUrl = State(initialValue: NSURL(string: videoFileData.downloadURL))
        } else {
            self._videoNsUrl = State(initialValue: nil)
        }
        
        if let eventData = assetToEdit.suggestedEvent {
            self._eventNote = State(initialValue: eventData.note)
            self._eventLatitude = State(initialValue: eventData.latitude)
            self._eventLongitude = State(initialValue: eventData.longitude)
        } else {
            self._eventNote = State(initialValue: "")
            self._eventLatitude = State(initialValue: nil)
            self._eventLongitude = State(initialValue: nil)
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
                        header: Text("general").padding(.top)
                    ) {
                        TextField("name", text: $name)
                            .disableAutocorrection(true)
                            .autocapitalization(.words)
                        TextField("code", text: $code)
                            .disableAutocorrection(true)
                            .autocapitalization(.allCharacters)
                        TextField(descriptionPlaceholderString, text: $description)
                    }
                    
                    Section(
                        header: Text("icon")
                    ) {
                        Button {
                            activeSheet = .image
                        } label: {
                            HStack {
                                Text("select")
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
                                    Text("remove")
                                    Spacer()
                                }
                                .foregroundColor(.red)
                            }
                        }
                    }
                    
                    Section(
                        header: Text("video")
                    ) {
                        Button {
                            activeSheet = .video
                        } label: {
                            HStack {
                                Text("select")
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
                                    Text("remove")
                                    Spacer()
                                }
                                .foregroundColor(.red)
                            }
                        }
                    }
                    
                    Section(
                        header: Text("event")
                    ) {
                        Button {
                            activeSheet = .map
                        } label: {
                            HStack {
                                Text("pick_location")
                                Spacer()
                            }
                        }
                        
                        if let eventLatitude = eventLatitude,
                           let eventLongitude = eventLongitude {
                            HStack {
                                Text("latitude")
                                Spacer()
                                Text(String(eventLatitude))
                            }
                            .foregroundColor(.secondary)
                            
                            HStack {
                                Text("longitude")
                                Spacer()
                                Text(String(eventLongitude))
                            }
                            .foregroundColor(.secondary)
                            
                            TextField(notePlaceholderString, text: $eventNote)
                            
                            Button {
                                withAnimation {
                                    self.eventNote = ""
                                    self.eventLatitude = nil
                                    self.eventLongitude = nil
                                }
                            } label: {
                                HStack {
                                    Text("remove")
                                    Spacer()
                                }
                                .foregroundColor(.red)
                            }
                        }
                    }
                    
                    if let assetToEdit = assetToEdit {
                        Section {
                            Button {
                                withAnimation {
                                    progress = true
                                }
                                
                                print("Deleting \(assetToEdit)")
                                
                                session.deleteRemoteAsset(asset: assetToEdit) { (error) in
                                    progress = false
                                    
                                    if error == nil {
                                        additionalOnDeleteAction?()
                                        isPresented.toggle()
                                    }
                                }
                            } label: {
                                HStack {
                                    Spacer()
                                    Text("delete")
                                    Spacer()
                                }
                            }
                            .foregroundColor(.red)
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
                    case .map:
                        GoogleMapsLocationPickerView(latitude: $eventLatitude, longitude: $eventLongitude)
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("back") {
                            isPresented.toggle()
                        }
                    }
                    
                    ToolbarItem(placement: .confirmationAction) {
                        Button("save") {
                            withAnimation {
                                progress = true
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                let event: CryptoEvent?
                                if let eventLatitude = eventLatitude,
                                   let eventLongitude = eventLongitude {
                                    event = CryptoEvent(note: eventNote, latitude: eventLatitude, longitude: eventLongitude)
                                } else {
                                    event = nil
                                }
                                
                                let asset = CryptoAsset(
                                    id: assetToEdit?.id ?? UUID().uuidString,
                                    name: name,
                                    code: code,
                                    description: description,
                                    iconFileData: assetToEdit?.iconFileData,
                                    videoFileData: assetToEdit?.videoFileData,
                                    suggestedEvent: event
                                )
                                
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

