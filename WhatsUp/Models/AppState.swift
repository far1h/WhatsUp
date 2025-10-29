//
//  AppState.swift
//  WhatsUp
//
//  Created by Farih Muhammad on 29/10/2025.
//

import Foundation

enum Route: Hashable {
    case main
    case login
    case signUp
}

class AppState: ObservableObject {
    @Published var isUserLoggedIn: Bool = false
    @Published var routes = [Route]()
}
