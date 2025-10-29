//
//  ChatMessageListView.swift
//  WhatsUp
//
//  Created by Farih Muhammad on 29/10/2025.
//

import SwiftUI
import FirebaseAuth

struct ChatMessageListView: View {
    
    let messages: [ChatMessage]
    
    private func isFromCurrentUser(_ message: ChatMessage) -> (ChatMessageType, Color) {
        if message.userId == Auth.auth().currentUser?.uid {
            return (.sent, .blue)
        } else {
            return (.received, .black.opacity(0.8))
        }
    }
    
    var body: some View {
        
        ScrollView {
            VStack {
                ForEach (messages) { message in
                    let (direction, color) = isFromCurrentUser(message)
                    HStack {
                        ChatMessageView(message: message, direction: direction, color: color)
                    }.listRowSeparator(.hidden)
                    Spacer().frame(height: 5)
                        .id(message.id)
                }.listStyle(PlainListStyle())
            }
            .padding()
            .padding(.bottom, 50)
        }
        
    }
}

struct ChatMessageListView_Previews: PreviewProvider {
    static var previews: some View {
        ChatMessageListView(messages: [
            ChatMessage(text: "Hello!", userId: "user1", dateCreated: Date(), displayName: "Alice"),
            ChatMessage(text: "Hi there!", userId: "user2", dateCreated: Date(), displayName: "Bob")
            
        ])
    }
}
