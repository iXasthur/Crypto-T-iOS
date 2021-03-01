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
    
    @State var errorText: String = ""
    
    @State var progress: Bool = false
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                ScrollView(showsIndicators: false) {
                    VStack {
                        Text("welcome_exclamation_mark")
                            .font(.largeTitle)
                            .fontWeight(.semibold)
                        
                        VStack(spacing: 10) {
                            HStack {
                                Image(systemName: "person")
                                    .foregroundColor(.secondary)
                                TextField("email", text: $email)
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
                                SecureField("password", text: $password)
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
                                signUpTap()
                            }) {
                                Text("sign_up")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity, minHeight: 50)
                                    .background(Color.blue.opacity(0.4))
                                    .cornerRadius(Constants.uiCornerRadius)
                            }
                            
                            Button(action: {
                                signInTap()
                            }) {
                                Text("sign_in")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity, minHeight: 50)
                                    .background(Color.green.opacity(0.8))
                                    .cornerRadius(Constants.uiCornerRadius)
                            }
                        }
                        .padding(.bottom, 25)
                        
                        Text(errorText)
                            .fontWeight(.semibold)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                    .frame(width: geometry.size.width)
                    .frame(minHeight: geometry.size.height)
                }
            }
            
            
            if progress {
                ProgressView()
            }
        }
        .allowsHitTesting(!progress)
        .onAppear {
            restoreSession()
        }
    }
    
    func validateEmailPassword() -> Bool {
        var newErrorText: String? = nil
        
        if email.isEmpty {
            newErrorText = (newErrorText ?? "") + "Email must be not empty."
        }
        
        if password.isEmpty {
            if newErrorText != nil {
                newErrorText = newErrorText! + "\nPassword must be not empty."
            } else {
                newErrorText = "Password must be not empty."
            }
        }
        
        if newErrorText != nil {
            errorText = newErrorText!
            return false
        } else {
            return true
        }
    }
    
    func restoreSession() {
        withAnimation {
            progress = true
        }
        
        if let authData = session.restore(completion: { (error) in
            withAnimation {
                progress = false
            }
            
            if let error = error {
                self.errorText = error.localizedDescription
            }
        }) {
            email = authData.email
            password = authData.password
        }
    }
    
    func signInTap() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        
        if validateEmailPassword() {
            withAnimation {
                progress = true
            }
            
            session.signInEmail(email: email, password: password) { (error) in
                withAnimation {
                    progress = false
                }
                
                if let error = error {
                    self.errorText = error.localizedDescription
                }
            }
        }
    }
    
    func signUpTap() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        
        if validateEmailPassword() {
            withAnimation {
                progress = true
            }
            
            session.signUpEmail(email: email, password: password) { (error) in
                withAnimation {
                    progress = false
                }
                
                if let error = error {
                    self.errorText = error.localizedDescription
                }
            }
        }
    }
}
