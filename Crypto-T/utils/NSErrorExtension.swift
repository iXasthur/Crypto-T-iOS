//
//  NSErrorExtension.swift
//  Crypto-T
//
//  Created by Михаил Ковалевский on 26.02.2021.
//

import Foundation


extension NSError {
    static func withLocalizedDescription(_ s: String) -> NSError {
        return NSError(
            domain: "",
            code: 0,
            userInfo: [
                NSLocalizedDescriptionKey : s
            ])
    }
}
