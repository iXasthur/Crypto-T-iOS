//
//  CryptoAsset.swift
//  Crypto-T
//
//  Created by Михаил Ковалевский on 23.02.2021.
//

import Foundation


struct CryptoAsset: Codable {
    var id: String
    var providerProfileId: String // id
    var name: String // Bitcoin
    var code: String // BTC
    var description: String // ...
    var iconURL: String // url
    var promoVideoURL: String // url
}
