//
//  CryptosListView.swift
//  Crypto-T
//
//  Created by Михаил Ковалевский on 26.02.2021.
//

import SwiftUI

struct CryptosListView: View {
    
    let title = "Cryptos"
    
    @EnvironmentObject var session: Session
    
    var body: some View {
        NavigationView {
            ScrollView {
                if let assets = session.dashboard?.assets {
                    LazyVStack {
                        ForEach(assets) { asset in
                            CryptoCellView(asset: asset)
                                .padding(.vertical)
                        }
                    }
                    .padding()
                } else {
                    Text("There is no cryptos")
                        .multilineTextAlignment(.center)
                        .padding()
                        .navigationBarTitle(title)
                }
            }
            .navigationBarTitle(title)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        print("Tapped plus!")
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
}
