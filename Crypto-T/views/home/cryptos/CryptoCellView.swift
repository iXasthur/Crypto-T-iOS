//
//  CryptoCellView.swift
//  Crypto-T
//
//  Created by Михаил Ковалевский on 26.02.2021.
//

import SwiftUI

struct CryptoCellView: View {
    
    let asset: CryptoAsset
    
    var body: some View {
        VStack {
            NavigationLink(
                destination: CryptoDetailsView(asset: asset)
            ) {
                HStack {
                    Image(systemName: "cube")
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
