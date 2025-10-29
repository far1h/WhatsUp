//
//  WhatsUpApp.swift
//  WhatsUp
//
//  Created by Farih Muhammad on 29/10/2025.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth

@main
struct WhatsUpApp: App {
    init() {
        FirebaseApp.configure()
    }
    
    @StateObject var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack (path: $appState.routes) {
                ZStack {
                    if Auth.auth().currentUser != nil {
                        MainView()
                    } else {
                        LoginView()
                    }
                }.navigationDestination(for: Route.self) { route in
                    switch route {
                    case .main:
                        MainView()
                    case .login:
                        LoginView()
                    case .signUp:
                        SignUpView()
                    }
                }
            }.environmentObject(appState)
                .environmentObject(Model())
        }
    }
}
