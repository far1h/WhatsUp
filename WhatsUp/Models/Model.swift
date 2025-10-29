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
    @Published var chatMessages: [ChatMessage] = []
    
    var fireStoreListener: ListenerRegistration? = nil
    
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
    
    func detachListener() {
        fireStoreListener?.remove()
        fireStoreListener = nil
    }
    
    func listenForChatMessages(in group: Group) {
        chatMessages.removeAll()
        let db = Firestore.firestore()
        guard let groupId = group.documentId else { return }
        self.fireStoreListener = db.collection("groups").document(groupId).collection("messages").order(by: "dateCreated", descending: false).addSnapshotListener { snapshot, error in
            guard let snapshot = snapshot else {
                print("Error fetching chat messages: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            snapshot.documentChanges.forEach { change in
                if change.type == .added {
                    let chatMessage = ChatMessage.fromSnapshot(snapshot: change.document)
                    if let chatMessage {
                        if !self.chatMessages.contains(chatMessage) {
                            self.chatMessages.append(chatMessage)
                        }
                    }
                }
            }
        }
        
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
