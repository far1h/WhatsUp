//
//  ChatMessage.swift
//  WhatsUp
//
//  Created by Farih Muhammad on 29/10/2025.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

struct ChatMessage: Identifiable, Codable, Hashable, Equatable {
    var documentId: String? = nil
    let text: String
    let userId: String
    let dateCreated: Date
    let displayName: String
    
    var id: String {
        documentId ?? UUID().uuidString
    }
}

extension ChatMessage {

    
    func toDictionary() -> [String: Any] {
        return [
            "text": text,
            "dateCreated": dateCreated,
            "senderId": userId,
            "displayName": displayName
        ]
    }
    
    static func fromSnapshot(snapshot: QueryDocumentSnapshot) -> ChatMessage? {
        let data = snapshot.data()
        guard let text = data["text"] as? String,
              let dateCreated = data["dateCreated"] as? Timestamp,
              let senderId = data["senderId"] as? String,
              let displayName = data["displayName"] as? String else {
            return nil
        }
        
        let documentId = snapshot.documentID
        let dateCreatedDate = dateCreated.dateValue()

        
        return ChatMessage(documentId: documentId, text: text, userId: senderId, dateCreated: dateCreatedDate, displayName: displayName)
    }
}
