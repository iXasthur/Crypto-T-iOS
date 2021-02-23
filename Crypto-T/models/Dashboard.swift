//
//  Dashboard.swift
//  Crypto-T
//
//  Created by Михаил Ковалевский on 23.02.2021.
//

import Foundation


class Dashboard: ObservableObject {
    @Published var authData: AuthData? = nil
    @Published var settingsData: SettingsData = SettingsData.restore()
    @Published var networks: [CryptoNetwork] = []
}
