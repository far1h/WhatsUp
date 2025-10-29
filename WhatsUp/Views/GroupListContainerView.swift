//
//  GroupListContainerView.swift
//  WhatsUp
//
//  Created by Farih Muhammad on 29/10/2025.
//

import SwiftUI

struct GroupListContainerView: View {
    @EnvironmentObject var model: Model
    @State private var isPresented: Bool = false
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button (action: {
                    isPresented.toggle()
                }) {
                    Image(systemName: "plus")
                        .font(.title)
                        .padding(.bottom, 8)
                }
            }
            GroupListView(groups: model.groups)
            Spacer()
        }.padding()
            .sheet(isPresented: $isPresented) {
                AddNewGroupView()
            }
            .task {
                do {
                    try await model.populateGroups()
                } catch {
                    print("Error fetching groups: \(error.localizedDescription)")
                }
            }
    }
}

struct GroupListContainerView_Previews: PreviewProvider {
    static var previews: some View {
        GroupListContainerView().environmentObject(Model())
    }
}
