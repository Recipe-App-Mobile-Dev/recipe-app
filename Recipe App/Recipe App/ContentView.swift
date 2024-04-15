//
//  ContentView.swift
//  Recipe App
//
//  Created by Galina Abdurashitova on 08.04.2024.
//

import SwiftUI

struct ContentView: View {    
    var body: some View {
//        VStack {
//            Image(systemName: "globe")
//                .imageScale(.large)
//                .foregroundStyle(.tint)
//            Text("Hello, world!")
//        }
//        .padding()
//        
        NavigationView {
            NavigationLink(destination: RecipeView(recipe: RecipesDummyData.ToastRecipe)) {
                Text("RecipeView")
            }
        }
    }
}

#Preview {
    ContentView()
}
