//
//  CryptoCellView.swift
//  Crypto-T
//
//  Created by Михаил Ковалевский on 26.02.2021.
//

import SwiftUI
import URLImage

struct CryptoCellView: View {
    
    let asset: CryptoAsset
    
    var placeholderIcon: some View {
        Image(systemName: "cube")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .scaleEffect(0.5)
            .frame(width: 30, height: 30)
            .overlay(Circle().stroke(Color.purple.opacity(0.5), lineWidth: 2))
    }
    
    var body: some View {
        VStack {
            NavigationLink(
                destination: CryptoDetailsView(asset: asset)
            ) {
                HStack {
                    if let iconURLString = asset.iconImageData?.downloadURL,
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
                                        .frame(width: 30, height: 30)
                                        .clipShape(Circle())
                                        .overlay(Circle().stroke(Color.purple.opacity(0.5), lineWidth: 2))
                                 }
                        )
                    } else {
                        placeholderIcon
                    }
                    
                    Text(asset.name)
                    Spacer()
                    Image(systemName: "arrow.right")
                        .imageScale(.small)
                        .foregroundColor(.secondary)
                }
            }
            .foregroundColor(.primary)
        }
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: Constants.uiCornerRadius)
                .stroke(Color.purple.opacity(0.5), lineWidth: 2)
        )
    }
}
