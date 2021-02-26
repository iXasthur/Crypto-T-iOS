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
            if let platforms = session.dashboard?.platforms {
                ScrollView {
                    LazyVStack {
                        ForEach(platforms) { platform in
                            PlatformCellView(platform: platform)
                                .padding(.vertical)
                        }
                    }
                    .padding()
                }
                .navigationBarTitle(title)
            } else {
                Text("There is no platforms avaliable right now")
                    .multilineTextAlignment(.center)
                    .padding()
                    .navigationBarTitle(title)
            }
        }
    }
}
