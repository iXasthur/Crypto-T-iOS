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
    
    let imageSize: CGFloat = 100
    
    let asset: CryptoAsset
    
    var placeholderIcon: some View {
        Image(systemName: "cube")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .scaleEffect(0.5)
            .frame(width: imageSize, height: imageSize)
            .overlay(Circle().stroke(Color.purple.opacity(0.5), lineWidth: 3))
    }
    
    var body: some View {
        Form {
            HStack {
                Spacer()
                if let iconURLString = asset.iconFileData?.downloadURL,
                   let iconURL = URL(string: iconURLString) {
                    URLImage(url: iconURL,
                             empty: {
                                placeholderIcon
                             },
                             inProgress: { _ in
                                placeholderIcon
                             },
                             failure: { _, _ in
                                placeholderIcon
                             },
                             content: { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: imageSize, height: imageSize)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.purple.opacity(0.5), lineWidth: 3))
                             }
                    )
                } else {
                    placeholderIcon
                }
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
