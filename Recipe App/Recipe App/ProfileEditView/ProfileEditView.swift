//
//  ProfileEditView.swift
//  Recipe App
//
//  Created by Jin Mizuno on 06/05/2024.
//

import Foundation
import SwiftUI

struct ProfileEditView: View {
    @StateObject var viewModel: ProfileEditViewModel
    @State private var showingImagePicker = false
    @Environment(\.presentationMode) var presentationMode
    @Binding var path: NavigationPath
    var authModel: AuthModel

    init(authModel: AuthModel, path: Binding<NavigationPath>) {
        _viewModel = StateObject(wrappedValue: ProfileEditViewModel(profile: authModel.profile))
        self.authModel = authModel
        _path = path
    }
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            Button(action: {
                showingImagePicker = true
            }) {
                if let image = viewModel.selectedImage {
                    Image(uiImage: image)
                        .resizable()
                } else {
                    LoadImageView(imageName: "profiles/\(viewModel.profile.uid)/profile.jpg", defaultImage: Image("defaultIcon"))
                }
            }
            .scaledToFill()
            .clipShape(Circle())
            .frame(width: 200, height: 200)
            .padding(.leading)
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $viewModel.selectedImage)
            }

            CustomTextField(label: "Name", placeHolder: "Enter your Name", text: $viewModel.editedName)
                .padding()

            Button(action: {
                viewModel.saveProfileChanges()
            }) {
                ButtonView(text: "Save", color: Color.green)
            }
            .padding(.horizontal, 10.0)
            Spacer()
        }
        .onAppear {
            viewModel.onSaveCompleted = {
                presentationMode.wrappedValue.dismiss()
            }
        }
        .padding()
    }
}

struct ProfileEditView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileEditView(authModel: AuthModel(testProfile: true),
        path: Binding<NavigationPath>(
            get: { return NavigationPath() },
            set: { _ in }
        ))
    }
}
