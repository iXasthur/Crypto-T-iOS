//
//  CryptoAsset.swift
//  Crypto-T
//
//  Created by Михаил Ковалевский on 23.02.2021.
//

import Foundation
import Firebase


struct CryptoAsset: Codable, Identifiable {
    var id: String
    var name: String // Bitcoin
    var code: String // BTC
    var description: String // ...
    
    var iconImageData: CloudFileData?
}
