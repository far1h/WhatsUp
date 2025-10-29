//
//  GroupListView.swift
//  WhatsUp
//
//  Created by Farih Muhammad on 29/10/2025.
//

import SwiftUI

struct GroupListView: View {
    
    let groups: [Group]
    var body: some View {
        List(groups) { group in
            NavigationLink {
//                GroupDetailView(group: group)
                Text("Group Detail View for \(group.subject)")
            } label: {
                HStack {
                    Image(systemName: "person.3.fill")
                    Text(group.subject)
                }
            }

        }.listStyle(.plain)
    }
}

struct GroupListView_Previews: PreviewProvider {
    static var previews: some View {
        GroupListView(groups: [
                Group(subject: "Study Group"),
                Group(subject: "Family"),
                Group(subject: "Work Buddies")
        ])
    }
}
