//
//  CryptoDetailsView.swift
//  Crypto-T
//
//  Created by Михаил Ковалевский on 23.02.2021.
//

import SwiftUI

struct CryptoDetailsView: View {
    
    let asset: CryptoAsset
    
    var body: some View {
        Text(asset.name)
    }
}
