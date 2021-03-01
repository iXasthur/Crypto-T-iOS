//
//  CryptoAsset.swift
//  Crypto-T
//
//  Created by Михаил Ковалевский on 23.02.2021.
//

import Foundation


struct CryptoAsset: Codable, Identifiable {
    var id: String
    var name: String // Bitcoin
    var code: String // BTC
    var description: String // ...
    
    var iconFileData: CloudFileData?
    var videoFileData: CloudFileData?
    
    var suggestedEvent: CryptoEvent?
}
