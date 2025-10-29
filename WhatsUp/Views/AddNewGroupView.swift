//
//  AddNewGroupView.swift
//  WhatsUp
//
//  Created by Farih Muhammad on 29/10/2025.
//

import SwiftUI

struct AddNewGroupView: View {
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var model: Model
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
                        model.saveGroup(group: Group(subject: groupSubject)) { error in
                            if let error = error {
                                print("Error creating group: \(error.localizedDescription)")
                            } else {
                                dismiss()
                            }
                        }
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
        AddNewGroupView().environmentObject(Model())
    }
}
