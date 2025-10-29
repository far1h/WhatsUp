//
//  GroupListContainerView.swift
//  WhatsUp
//
//  Created by Farih Muhammad on 29/10/2025.
//

import SwiftUI

struct GroupListContainerView: View {
    
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
                }
            }
            Spacer()
        }.padding()
            .sheet(isPresented: $isPresented) {
                AddNewGroupView()
            }
    }
}

struct GroupListContainerView_Previews: PreviewProvider {
    static var previews: some View {
        GroupListContainerView()
    }
}
