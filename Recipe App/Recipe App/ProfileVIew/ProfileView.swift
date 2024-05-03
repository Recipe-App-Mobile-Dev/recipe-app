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
        if let fetchedRecipes = viewModel.recipes {
            ScrollView {
                VStack {
                    HStack {
                        ProfileCardView(profile: authModel.profile)
                        Image(systemName: "pencil")
                            .padding(.trailing, 20)
                        
                    }.padding(.top, 30)
                    
                    ScrollView {
                        VStack(spacing: 20) {
                            ForEach(fetchedRecipes.sorted(by: { $0.dateCreated > $1.dateCreated }), id: \.recipeName) { recipe in
                                NavigationLink(destination: LazyView(RecipeView(recipe: recipe, auth: authModel))) {
                                    RecipeCardView(imageName: recipe.imageName, recipeName: recipe.recipeName)
                                }
                            }
                        }
                        .padding()
                        .padding(.top, 20)
                        
                        Button("Log Out") {
                            authModel.signOut()
                        }
                    }
                }
            }
            .navigationTitle("Profile")
            .onAppear {
                viewModel.fetchUserRecipes(userId: authModel.profile.uid)
            }
        }
    }
}

#Preview {
    ProfileView(test: true, authModel: AuthModel(testProfile: true))
}
