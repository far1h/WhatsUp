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
        List{
            ForEach(groups) { group in
                NavigationLink(destination: GroupDetailView(group: group)) {
                    HStack {
                        Image(systemName: "person.3.fill")
                        Text(group.subject)
                        Spacer()
                    }
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
