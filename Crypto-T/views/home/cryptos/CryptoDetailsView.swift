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
    
    let asset: CryptoAsset
    
    var body: some View {
        Form {
            HStack {
                Spacer()
                CryptoIconView(asset.iconFileData?.downloadURL, 100)
                Spacer()
            }
            
            Section(header:
                        Text("DESCRIPTION")
            ) {
                Text(asset.description)
                    .multilineTextAlignment(.leading)
            }
            
            if  let urlString = asset.videoFileData?.downloadURL,
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
            
        }
        .navigationTitle(asset.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    print("tapped edit")
                } label: {
                    Image(systemName: "pencil")
                }
            }
        }
    }
}
