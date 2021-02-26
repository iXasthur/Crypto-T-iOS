//
//  PlatformsListView.swift
//  Crypto-T
//
//  Created by Михаил Ковалевский on 23.02.2021.
//

import SwiftUI

struct PlatformsListView: View {
    
    let title = "Platforms"
    
    @EnvironmentObject var session: Session
    
    var body: some View {
        NavigationView {
            ScrollView {
                if let platforms = session.dashboard?.platforms {
                    LazyVStack {
                        ForEach(platforms) { platform in
                            PlatformCellView(platform: platform)
                                .padding(.vertical)
                        }
                    }
                    .padding()
                } else {
                    Text("There is no platforms")
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
