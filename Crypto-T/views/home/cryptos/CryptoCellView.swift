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
        HStack {
            CryptoIconView(asset.iconFileData?.downloadURL, 50)
            VStack(alignment: .leading) {
                Text(asset.name)
                Text(asset.code)
                    .foregroundColor(.secondary)
            }
            .padding(.leading, 5)
            Spacer()
            Image(systemName: "arrow.right")
                .imageScale(.small)
                .foregroundColor(.secondary)
        }
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: Constants.uiCornerRadius)
                .stroke(Color.purple.opacity(0.5), lineWidth: 2)
        )
    }
}
