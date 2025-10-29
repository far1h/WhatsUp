//
//  GroupDetailView.swift
//  WhatsUp
//
//  Created by Farih Muhammad on 29/10/2025.
//

import SwiftUI

struct GroupDetailView: View {
    
    let group: Group
    
    @EnvironmentObject var model: Model
    
    @State private var chatText: String = ""
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                TextField("Type a message...", text: $chatText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                Button("Send") {
                    model.saveChatMessagesToFirestore(text: chatText, group: group) { error in
                        if let error = error {
                            print("Error sending message: \(error.localizedDescription)")
                        } else {
                            chatText = ""
                        }
                    }
                }
            }
        }.padding()
    }
}

struct GroupDetailView_Previews: PreviewProvider {
    static var previews: some View {
        GroupDetailView(group: Group(subject: "Sample Group")).environmentObject(Model())
    }
}
