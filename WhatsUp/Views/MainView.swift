//
//  MainView.swift
//  WhatsUp
//
//  Created by Farih Muhammad on 29/10/2025.
//

import SwiftUI
import FirebaseAuth

struct MainView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        TabView {
            GroupListContainerView()
                .tabItem {
                    Label("Chats", systemImage: "message.fill")
                }
            Button(action: {
                do {
                    try Auth.auth().signOut()
                    dismiss()
                } catch {
                    print("Error signing out: \(error.localizedDescription)")
                }
            }, label: {
                Text("Sign Out")
            })
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
