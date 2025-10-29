//
//  AddNewGroupView.swift
//  WhatsUp
//
//  Created by Farih Muhammad on 29/10/2025.
//

import SwiftUI

struct AddNewGroupView: View {
    
    @Environment(\.dismiss) private var dismiss
    @State private var groupSubject: String = ""
    
    private var isFormValid: Bool {
        !groupSubject.isEmptyOrWhiteSpace
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    TextField("Enter group subject", text: $groupSubject)
                        .padding()
                }
                Spacer()
            }.toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Create") {
                        // Action to create a new group
                    }
                    .disabled(!isFormValid)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .principal) {
                    Text("New Group")
                        .font(.headline)
                }
        }
        }
    }
}

struct AddNewGroupView_Previews: PreviewProvider {
    static var previews: some View {
        AddNewGroupView()
    }
}
