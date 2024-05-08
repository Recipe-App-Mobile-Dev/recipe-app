//
//  ProfileView.swift
//  Recipe App
//
//  Created by Jin Mizuno on 30/04/2024.
//

import Foundation
import SwiftUI

struct ProfileView: View {
    @ObservedObject var viewModel: ProfileViewModel
    var authModel: AuthModel
    
    init(test: Bool? = false, authModel: AuthModel) {
        viewModel = ProfileViewModel(test: test, userId: authModel.profile.uid)
        self.authModel = authModel
    }

    var body: some View {
        if let fetchedProfile = viewModel.profile {
            ScrollView {
                VStack {
                    HStack {
                        HStack {
                            LoadImageView(imageName: "profiles/\(fetchedProfile.uid)/profile.jpg", defaultImage: Image("defaultIcon"))
                                .scaledToFill()
                                .clipShape(Circle())
                                .frame(width: 60, height: 60)
                                .padding(.leading)
                            VStack(alignment: .leading) {
                                Text(fetchedProfile.name)
                                    .font(.headline)
                            }
                            .padding(.leading)
                        }.padding()
                        Spacer()
                        NavigationLink(destination: ProfileEditView(authModel: authModel)) {
                            Image(systemName: "pencil")
                                .padding(.trailing, 20)
                        }
                    }.padding(.top, 30)
                    if let fetchedRecipes = viewModel.recipes {
                        VStack(spacing: 20) {
                            ForEach(fetchedRecipes.sorted(by: { $0.dateCreated > $1.dateCreated }), id: \.id) { recipe in
                                NavigationLink(destination: LazyView(RecipeView(recipe: recipe, auth: authModel))) {
                                    RecipeCardView(recipe: recipe)
                                }
                            }
                        }
                        .padding()
                        .padding(.top, 20)
                    }
                    
                    Button("Log Out") {
                        authModel.signOut()
                    }
                }
            }
            .navigationTitle("Profile")
            .onAppear {
                viewModel.fetchUserRecipes(userId: authModel.profile.uid)
                viewModel.fetchUserProfile(userId: authModel.profile.uid)
            }
        }
    }
}

#Preview {
    ProfileView(
        test: true,
        authModel: AuthModel(testProfile: true)
    )
}
