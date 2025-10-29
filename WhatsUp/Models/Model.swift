//
//  Model.swift
//  WhatsUp
//
//  Created by Farih Muhammad on 29/10/2025.
//

import FirebaseAuth
import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

@MainActor
class Model: ObservableObject {
    
    @Published var groups: [Group] = []
    
    func updateDisplayName(for user: User, to newName: String) async throws {
        let changeRequest = user.createProfileChangeRequest()
        changeRequest.displayName = newName
        try await changeRequest.commitChanges()
    }
    
    func populateGroups() async throws {
        let db = Firestore.firestore()
        let snapshot = try await db.collection("groups").getDocuments()
        groups = snapshot.documents.compactMap { Group.fromSnapshot(snapshot: $0) }
    }
    
    func saveChatMessagesToFirestore(chatMessage: ChatMessage, group: Group) async throws {
        let db = Firestore.firestore()
        guard let groupId = group.documentId else { return }
        try await db.collection("groups").document(groupId).collection("messages").addDocument(data: chatMessage.toDictionary())
    }
    
    func saveGroup(group: Group, completion: @escaping (Error?) -> Void) {
        let db = Firestore.firestore()
        let docRef = db.collection("groups").addDocument(data: group.toDictionary()) { error in
            completion(error)
        }
        if let documentId = docRef.documentID as String? {
            var savedGroup = group
            savedGroup.documentId = documentId
            self.groups.append(savedGroup)
        }
        completion(nil)

    }
}
