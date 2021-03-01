//
//  MultilineTextField.swift
//  Crypto-T
//
//  Created by Михаил Ковалевский on 01.03.2021.
//

import SwiftUI

struct MultilineTextField: View {
    
    var placeholder: String
    @Binding var text: String
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(Color(UIColor.placeholderText))
                    .padding(.top, 8)
            }
            TextEditor(text: $text).padding(.leading, -4)
        }
    }
}
