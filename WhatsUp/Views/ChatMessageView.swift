//
//  ChatMessageView.swift
//  WhatsUp
//
//  Created by Farih Muhammad on 29/10/2025.
//

import MarkdownUI
import SwiftUI

enum ChatMessageType {
    case sent
    case received
}

struct ChatMessageView: View {
    let message: ChatMessage
    let direction: ChatMessageType
    let color: Color
    
    var body: some View {
        HStack {
            if direction == .sent {
                Spacer()
            }
            if direction == .received {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.black)
            }
            VStack(alignment: .leading) {
                Text(message.displayName)
                    .opacity(0.8)
                    .font(.caption)
                Markdown(message.text)
                    .padding(.bottom, 10)
                    .colorScheme(.dark)
                    .frame(minWidth: 50, alignment: .leading)
            }.padding(8)
                .background(color)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(
                        Text(message.dateCreated, style: .time)
                            .font(.caption2)
                            .opacity(0.4)
                            .foregroundColor(.white)
                            .padding([.bottom, .trailing], 4),
                        alignment: .bottomTrailing
                )
            if direction == .sent {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.black)
            }
            if direction == .received {
                Spacer()
            }
            
        }
            
    }
}

struct ChatMessageView_Previews: PreviewProvider {
    static var previews: some View {
        ChatMessageView(message: ChatMessage(text: ".", userId: "user1", dateCreated: Date(), displayName: "Alice"), direction: .sent, color: .black.opacity(0.8))
    }
}
