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
    @Published var geminiServeice = GeminiService()
    
    var fireStoreListener: ListenerRegistration? = nil
    
    private func updateUserInfoForAllMessages(for user: User) async throws {
        let db = Firestore.firestore()
        let groupsSnapshot = try await db.collection("groups").getDocuments()
        for groupDoc in groupsSnapshot.documents {
            let groupId = groupDoc.documentID
            let messagesSnapshot = try await db.collection("groups").document(groupId).collection("messages").whereField("senderId", isEqualTo: user.uid).getDocuments()
            for messageDoc in messagesSnapshot.documents {
                try await messageDoc.reference.updateData([
                    "displayName": user.displayName ?? ""
                ])
            }
        }
    }
    
    
    func updateDisplayName(for user: User, to newName: String) async throws {
        let changeRequest = user.createProfileChangeRequest()
        changeRequest.displayName = newName
        try await changeRequest.commitChanges()
        try await updateUserInfoForAllMessages(for: user)
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
        
        // if message contains @AI call getGeminiResponse
        if chatMessage.text.contains("@AI") {
            let prompt = chatMessage.toGeminiContentPart()
            let geminiResponse = try await getGeminiResponse(for: prompt)
            let aiChatMessage = ChatMessage(
                documentId: geminiResponse.responseId,
                text: geminiResponse.candidates.first?.content.parts.first?.text ?? "No response",
                userId: "AI_Assistant_ID",
                dateCreated: Date(),
                displayName: "AI Assistant"
            )
            try await db.collection("groups").document(groupId).collection("messages").addDocument(data: aiChatMessage.toDictionary())
        }
        
    }
    
    
    // func to call Gemini API and get response
    func getGeminiResponse(for prompt: [String: Any]) async throws -> GeminiResponse {
        
        // filteres Chat Messages with "@AI" as well as responses from displayName "AI Assistant"
        let messagesForAI = chatMessages.filter { message in
            return message.text.contains("@AI") || message.displayName == "AI Assistant"
        }
        // construct the request body
        var contents: [[String: Any]] = []
        for message in messagesForAI {
            let role = message.displayName == "AI Assistant" ? "model" : "user"
            let part: [String: Any] = [
                "text": message.text
            ]
            let contentPart: [String: Any] = [
                "role": role,
                "parts": [part]
            ]
            contents.append(contentPart)
        }
        contents.append(prompt)
        let systemPrompt: [String: Any] = [
            "parts": [
                ["text": "You are a helpful assistant that responds to user queries."]
            ]
        ]
        let requestBody: [String: Any] = [
            "system_instruction": systemPrompt,
            "contents": contents
        ]
        print("Request Body: \(requestBody)")
        let geminiResponse = try await geminiServeice.getGeminiResponse(for: requestBody)
        print("Gemini Response: \(String(describing: geminiResponse))")
        guard let geminiResponse = geminiResponse else {
            throw NSError(domain: "Gemini response is nil", code: -1, userInfo: nil)
        }
        return geminiResponse
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

//{
//    "candidates": [
//        {
//            "content": {
//                "parts": [
//                    {
//                        "text": "*My ears swivel, pinpointing your voice. I slowly uncurl from my sunbeam nap, stretching one paw out with claws just barely extended, a silent yawn escaping me. My emerald eyes blink open, fixing on you.*\n\n*My tail gives a slow, deliberate swish. \"Mrow?\" I question, tilting my head slightly, clearly waiting to see what you're offering.*"
//                    }
//                ],
//                "role": "model"
//            },
//            "finishReason": "STOP",
//            "index": 0
//        }
//    ],
//    "usageMetadata": {
//        "promptTokenCount": 13,
//        "candidatesTokenCount": 80,
//        "totalTokenCount": 905,
//        "promptTokensDetails": [
//            {
//                "modality": "TEXT",
//                "tokenCount": 13
//            }
//        ],
//        "thoughtsTokenCount": 812
//    },
//    "modelVersion": "gemini-2.5-flash",
//    "responseId": "JcYCaYvsHMm1juMPhuaH-Ac"
//}

struct GeminiResponse: Codable {
    let candidates: [Candidate]
    let responseId: String
}

struct Candidate: Codable {
    let content: Content
}

struct Content: Codable {
    let parts: [Part]
}

struct Part: Codable {
    let text: String
}
