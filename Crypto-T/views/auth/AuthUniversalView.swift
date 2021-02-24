//
//  AuthUniversalView.swift
//  Crypto-T
//
//  Created by Михаил Ковалевский on 24.02.2021.
//

import SwiftUI

struct AuthUniversalView: View {
    
    @EnvironmentObject var session: Session
    
    @State var email: String = ""
    @State var password: String = ""
    
    @State var errorText: String? = nil
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(showsIndicators: false) {
                VStack {
                    Text("Welcome!")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                    
                    VStack(spacing: 10) {
                        HStack {
                            Image(systemName: "person")
                                .foregroundColor(.secondary)
                            TextField("Email", text: $email)
                                .foregroundColor(.primary)
                                .disableAutocorrection(true)
                                .autocapitalization(.none)
                        }
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .overlay(
                            RoundedRectangle(cornerRadius: Constants.uiCornerRadius)
                                .stroke(Color.purple.opacity(0.5), lineWidth: 2)
                        )
                        
                        HStack {
                            Image(systemName: "key")
                                .foregroundColor(.secondary)
                            SecureField("Password", text: $password)
                                .foregroundColor(.primary)
                                .disableAutocorrection(true)
                                .autocapitalization(.none)
                        }
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .overlay(
                            RoundedRectangle(cornerRadius: Constants.uiCornerRadius)
                                .stroke(Color.purple.opacity(0.5), lineWidth: 2)
                        )
                    }
                    .padding(.bottom, 25)
                    
                    HStack {
                        Button(action: {
                            print("Sign Up")
                            
                        }) {
                            Text("Sign Up")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, minHeight: 50)
                                .background(Color.green.opacity(0.6))
                                .cornerRadius(Constants.uiCornerRadius)
                        }
                        
                        Button(action: {
                            print("Sign In")
                            
                        }) {
                            Text("Sign In")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, minHeight: 50)
                                .background(Color.green.opacity(0.8))
                                .cornerRadius(Constants.uiCornerRadius)
                        }
                    }
                    .padding(.bottom, 25)
                    
                    if errorText != nil {
                        Text(errorText!)
                            .fontWeight(.semibold)
                            .foregroundColor(.red)
                    }
                }
                .padding()
                .frame(width: geometry.size.width)
                .frame(minHeight: geometry.size.height)
            }
        }
    }
}
