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
        NavigationView {
            VStack {
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
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            isPresented = true
                        }) {
                            Image(systemName: "plus")
                        }
                    }
                }
        }
    }
}

struct GroupListContainerView_Previews: PreviewProvider {
    static var previews: some View {
        GroupListContainerView().environmentObject(Model())
    }
}
