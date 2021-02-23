//
//  CryptoNetwork.swift
//  Crypto-T
//
//  Created by Михаил Ковалевский on 23.02.2021.
//

import Foundation


struct CryptoNetwork: Codable {
    var id: String
    var name: String
    var creator: CryptoAsset
    var tokens: [CryptoAsset]
}
