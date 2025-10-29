//
//  GroupDetailView.swift
//  WhatsUp
//
//  Created by Farih Muhammad on 29/10/2025.
//

import SwiftUI
import FirebaseAuth

struct GroupDetailView: View {
    
    let group: Group
    
    @EnvironmentObject var model: Model
    
    @State private var chatText: String = ""
    
    private func sendMessage() async throws {
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        let message = ChatMessage(text: chatText, userId: currentUser.uid, dateCreated: Date(), displayName: currentUser.displayName ?? "Guest")
        try await model.saveChatMessagesToFirestore(chatMessage: message, group: group)
    }
    
    var body: some View {
        VStack {
            ChatMessageListView(messages: model.chatMessages)
            Spacer()
            HStack {
                TextField("Type a message...", text: $chatText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                Button("Send") {
                    Task {
                        do {
                            try await sendMessage()
                            chatText = ""
                        } catch {
                            print("Error sending message: \(error.localizedDescription)")
                        }
                    }
                }
            }
        }.padding()
            .onDisappear {
                model.detachListener()
            }
            .onAppear {
                model.listenForChatMessages(in: group)
            }
    }
}

struct GroupDetailView_Previews: PreviewProvider {
    static var previews: some View {
        GroupDetailView(group: Group(subject: "Sample Group"))
            .environmentObject(Model())
    }
}
