//
//  LoginView.swift
//  WhatsUp
//
//  Created by Farih Muhammad on 29/10/2025.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    
    @State private var email: String = ""
    @State private var password: String = ""
    
    private var isFormValid: Bool {
        !email.isEmptyOrWhiteSpace && !password.isEmptyOrWhiteSpace
    }
    
    private func login() async {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            print("Logged in user: \(result.user.email ?? "No Email")")
        } catch {
            print("Login error: \(error.localizedDescription)")
        }
    }
    
    var body: some View {
        Form {
            Section(header: Text("Login")) {
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                
                SecureField("Password", text: $password)
            }
            
            HStack {
                Spacer()
                Button(action: {
                    Task {
                        await login()
                    }
                }) {
                    Text("Login")
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .disabled(!isFormValid)
                Button(action: {
                    // Handle sign up action
                }) {
                    Text("Sign Up")
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                Spacer()
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
