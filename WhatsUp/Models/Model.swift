//
//  Model.swift
//  WhatsUp
//
//  Created by Farih Muhammad on 29/10/2025.
//

import FirebaseAuth
import Foundation

@MainActor
class Model: ObservableObject {
    
    func updateDisplayName(for user: User, to newName: String) async throws {
        let changeRequest = user.createProfileChangeRequest()
        changeRequest.displayName = newName
        try await changeRequest.commitChanges()
    }
}
