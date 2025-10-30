//
//  SettingsView.swift
//  WhatsUp
//
//  Created by Farih Muhammad on 30/10/2025.
//

import SwiftUI
import FirebaseAuth
struct SettingsConfig {
    var showPhotoOptions: Bool = false
    var sourceTypes: UIImagePickerController.SourceType?
    var selectedImage: UIImage?
    var displayedName: String = ""
}

struct SettingsView: View {
    
    @State private var config = SettingsConfig()
    @FocusState var isTextFieldFocused: Bool
    
    var body: some View {
        VStack {
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                .padding()
                .onTapGesture {
                    config.showPhotoOptions.toggle()
                }.confirmationDialog("Select Photo Source", isPresented: $config.showPhotoOptions, titleVisibility: .visible) {
                    Button("Camera") {
                        config.sourceTypes = .camera
                    }
                    Button("Photo Library") {
                        config.sourceTypes = .photoLibrary
                    }
                }
            TextField(config.displayedName.isEmpty ? "Enter your display name" : config.displayedName, text: $config.displayedName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .focused($isTextFieldFocused)
                .textInputAutocapitalization(.never)
            Spacer()
            Button(action: {
                do {
                    try Auth.auth().signOut()
                } catch {
                    print("Error signing out: \(error.localizedDescription)")
                }
            }, label: {
                Text("Sign Out")
            })
        }.sheet(item: $config.sourceTypes) { sourceType in
            ImagePicker(sourceType: sourceType, selectedImage: $config.selectedImage)
        }
        .onChange(of: config.selectedImage) { newImage in
            guard let image = newImage,
                  let imageData = image.jpegData(compressionQuality: 0.8) else {
                return
            }
            
        }
        .padding()
            .onAppear {
                if let currentUser = Auth.auth().currentUser {
                    config.displayedName = currentUser.displayName ?? "Guest "
                }
            }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
