//
//  CryptoIconView.swift
//  Crypto-T
//
//  Created by Михаил Ковалевский on 28.02.2021.
//

import SwiftUI
import URLImage


struct CryptoIconView: View {
    
    let url: URL?
    let size: CGFloat
    
    init(_ urlString: String?, _ size: CGFloat) {
        if let iconURLString = urlString,
           let iconURL = URL(string: iconURLString) {
            url = iconURL
        } else {
            if urlString != nil {
                print("Unable to process CryptoIconView urlString")
            }
            url = nil
        }
        
        self.size = size
    }
    
    var placeholderIcon: some View {
        Image(systemName: "cube")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .scaleEffect(0.5)
            .frame(width: size, height: size)
            .overlay(Circle().stroke(Color.purple.opacity(0.5), lineWidth: 2))
    }
    
    var body: some View {
        if let url = url {
            URLImage(url: url,
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
                            .frame(width: size, height: size)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.purple.opacity(0.5), lineWidth: 2))
                     }
            )
        } else {
            placeholderIcon
        }
    }
}
