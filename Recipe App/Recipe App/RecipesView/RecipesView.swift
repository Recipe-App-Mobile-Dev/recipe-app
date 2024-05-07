//
//  RecipesView.swift
//  Recipe App
//
//  Created by Jin Mizuno on 16/04/2024.
//

import SwiftUI
import Foundation

struct RecipesView: View {
    @ObservedObject var viewModel: RecipesViewModel
    var authModel: AuthModel

    init(test: Bool? = false, authModel: AuthModel) {
        viewModel = RecipesViewModel(test: test)
        self.authModel = authModel
    }

    var body: some View {
        if let fetchedRecipes = viewModel.recipes {
            GeometryReader { geometry in
                ZStack(alignment: .bottomTrailing) {
                    ScrollView {
                        Button("TEST add dummy recipe") {
                            RecipesDummyData.addDataToFirebase()
                        }
                        
                        VStack(spacing: 20) {
                            ForEach(fetchedRecipes.sorted(by: { $0.dateCreated > $1.dateCreated }), id: \.id) { recipe in
                                NavigationLink(destination: LazyView(RecipeView(recipe: recipe, auth: authModel))) {
                                    RecipeCardView(recipe: recipe)
                                }
                            }
                        }
                        .padding()
                    }
                        
                    NavigationLink(destination: AddRecipeView(auth: authModel)) {
                        Image(systemName: "plus")
                            .font(.title.weight(.semibold))
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                            .shadow(radius: 4, x: 0, y: 4)
                    }
                    .padding([.trailing, .bottom], 20)
                    .frame(maxWidth: geometry.size.width, maxHeight: geometry.size.height, alignment: .bottomTrailing)
                    
                }
                .navigationBarTitle("App Name", displayMode: .inline)
                .navigationBarItems(
                    leading: NavigationLink(destination: ProfileView(authModel: authModel)) {
                        Image(systemName: "person")
                    },
                    trailing: NavigationLink(destination: SearchView()) {
                        Image(systemName: "magnifyingglass")
                    }
                )
                .onAppear { viewModel.fetchRecipes() }
            }
        }
    }
}

struct LazyView<Content: View>: View {
    let build: () -> Content
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    var body: Content {
        build()
    }
}

struct RecipesView_Previews: PreviewProvider {
    static var previews: some View {
        RecipesView(
            test: true,
            authModel: AuthModel()
        )
    }
}
