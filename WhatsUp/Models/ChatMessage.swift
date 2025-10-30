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

    // convert messages to gemini body format
    /*
         curl "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent" \
         -H "x-goog-api-key: $GEMINI_API_KEY" \
         -H 'Content-Type: application/json' \
         -X POST \
         -d '{
         "contents": [
         {
         "role": "user",
         "parts": [
         { "text": "Hello." }
         ]
         },
         {
         "role": "model",
         "parts": [
         { "text": "Hello! How can I help you today?" }
         ]
         },
         {
         "role": "user",
         "parts": [
         { "text": "Please write a four-line poem about the ocean." }
         ]
         }
         ]
         }'
         */
    
    func toGeminiContentPart() -> [String: Any] {
        return [
            "role": "user",
            "parts": [
                ["text": text]
            ]
        ]
    }
    
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
