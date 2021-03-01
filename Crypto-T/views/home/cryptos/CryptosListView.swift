//
//  CryptosListView.swift
//  Crypto-T
//
//  Created by Михаил Ковалевский on 26.02.2021.
//

import SwiftUI

struct CryptosListView: View {
    
    let title = "cryptos"
    
    @EnvironmentObject var session: Session
    
    @State var showCryptoCreator: Bool = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                if let assets = session.getLocalAssets(), !assets.isEmpty {
                    LazyVStack {
                        ForEach(assets) { asset in
                            NavigationLink(
                                destination: CryptoDetailsView(asset: asset)
                            ) {
                                CryptoCellView(asset: asset)
                                    .padding(.top)
                            }
                            .foregroundColor(.primary)
                        }
                    }
                    .padding()
                } else {
                    Text("there_is_no_cryptos")
                        .multilineTextAlignment(.center)
                        .padding()
                        .navigationBarTitle(title)
                }
            }
            .navigationBarTitle(title, displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showCryptoCreator.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showCryptoCreator) {
                CryptoUniversalCEView(isPresented: $showCryptoCreator)
                    .environmentObject(session)
            }
        }
    }
}
