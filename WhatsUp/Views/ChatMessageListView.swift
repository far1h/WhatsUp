//
//  ChatMessageListView.swift
//  WhatsUp
//
//  Created by Farih Muhammad on 29/10/2025.
//

import SwiftUI

struct ChatMessageListView: View {
    
    let messages: [ChatMessage]
    
    var body: some View {
        List {
            ForEach(messages) { message in
                HStack {
                    VStack(alignment: .leading) {
                        Text(message.displayName)
                            .font(.headline)
                        Text(message.text)
                            .font(.body)
                    }
                    Spacer()
                }
                .padding(8)
            }
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
