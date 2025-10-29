//
//  SignUpView.swift
//  WhatsUp
//
//  Created by Farih Muhammad on 29/10/2025.
//

import SwiftUI
import FirebaseAuth

struct SignUpView: View {
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var displayName: String = ""
    @State private var errorMessage: String = ""
    
    private var isFormValid: Bool {
        return !email.isEmptyOrWhiteSpace && !password.isEmptyOrWhiteSpace && !displayName.isEmptyOrWhiteSpace
    }
    
    private func updateDisplayName(user: User) async {
        let changeRequest = user.createProfileChangeRequest()
        changeRequest.displayName = displayName
        do {
            try await changeRequest.commitChanges()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    private func signUp() async {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            await updateDisplayName(user: result.user)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    var body: some View {
        Form {
            Section(header: Text("Sign Up")) {
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                
                SecureField("Password", text: $password)
                
                TextField("Display Name", text: $displayName)
            }
            
            HStack {
                // Sign up and Log in buttons
                Spacer()
                Button(action: {
                    Task {
                        await signUp()
                    }
                }) {
                    Text("Sign Up")
                        .bold()
                }
                .disabled(!isFormValid)
                Spacer()
                Button(action: {
                    // Handle log in action
                }) {
                    Text("Log In")
                        .bold()
                }
                Spacer()
                
            }
            if !errorMessage.isEmpty {
                Section {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }

            }
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
