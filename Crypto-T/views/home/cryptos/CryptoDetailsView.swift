//
//  CryptoDetailsView.swift
//  Crypto-T
//
//  Created by Михаил Ковалевский on 23.02.2021.
//

import SwiftUI
import AVKit
import URLImage


struct CryptoDetailsView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    let asset: CryptoAsset
    
    @State var showCryptoEditor: Bool = false
    
    var body: some View {
        Form {
            HStack {
                Spacer()
                CryptoIconView(asset.iconFileData?.downloadURL, 110)
                Spacer()
            }
            
            Section(header:
                        Text("CODE")
            ) {
                Text(asset.code)
                    .multilineTextAlignment(.leading)
            }
            
            Section(header:
                        Text("DESCRIPTION")
            ) {
                Text(asset.description)
                    .multilineTextAlignment(.leading)
            }
            
            if let urlString = asset.videoFileData?.downloadURL,
               let url = URL(string: urlString) {
                let videoPlayer: AVPlayer = AVPlayer(url: url)
                
                Section(header:
                            Text("SUGGESTED VIDEO")
                ) {
                    VideoPlayer(player: videoPlayer)
                        .aspectRatio(16.0/9.0, contentMode: .fit)
                        .onDisappear(perform: {
                            videoPlayer.pause()
                        })
                }
            }
            
            if let eventData = asset.suggestedEvent {
                Section(header:
                            Text("SUGGESTED EVENT")
                ) {
                    Text(eventData.note)
                        .multilineTextAlignment(.leading)
                    HStack {
                        Text("Latitude")
                        Spacer()
                        Text(String(eventData.latitude))
                    }
                    .foregroundColor(.secondary)
                    
                    HStack {
                        Text("Longitude")
                        Spacer()
                        Text(String(eventData.longitude))
                    }
                    .foregroundColor(.secondary)
                }
            }
            
        }
        .navigationTitle(asset.name)
        .sheet(isPresented: $showCryptoEditor, content: {
            CryptoUniversalCEView(
                assetToEdit: asset,
                onDelete: {
                    presentationMode.wrappedValue.dismiss()
                },
                isPresented: $showCryptoEditor)
        })
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showCryptoEditor.toggle()
                } label: {
                    Image(systemName: "pencil")
                }
            }
        }
    }
}
