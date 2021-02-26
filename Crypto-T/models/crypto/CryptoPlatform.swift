//
//  CryptoPlatform.swift
//  Crypto-T
//
//  Created by Михаил Ковалевский on 23.02.2021.
//

import Foundation


struct CryptoPlatform: Codable, Identifiable {
    var id: String = UUID().uuidString
    
    var protocolName: String
    var creator: CryptoAsset
    var tokens: [CryptoAsset]
}
