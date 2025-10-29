//
//  ChatMessage.swift
//  WhatsUp
//
//  Created by Farih Muhammad on 29/10/2025.
//

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
            "timestamp": dateCreated,
            "senderId": userId,
            "displayName": displayName
        ]
    }
}
