//
//  PlatformCellView.swift
//  Crypto-T
//
//  Created by Михаил Ковалевский on 23.02.2021.
//

import SwiftUI

struct PlatformCellView: View {
    
    let platform: CryptoPlatform
    
    var body: some View {
        VStack {
            NavigationLink(
                destination: CryptoDetailsView(asset: platform.creator)
            ) {
                HStack {
                    Image(systemName: "network")
                    Text(platform.creator.name)
                    Spacer()
                    Image(systemName: "arrow.right")
                        .imageScale(.small)
                        .foregroundColor(.secondary)
                }
            }
            .foregroundColor(.primary)
            
            Divider()
            
            NavigationLink(
                destination: TokensListView()
            ) {
                HStack {
                    Text("Tokens")
                    Text("(\(platform.protocolName))")
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(String(platform.tokens.count))
                        .foregroundColor(.secondary)
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
