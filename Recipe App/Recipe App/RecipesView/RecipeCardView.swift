//
//  RecipeCardView.swift
//  Recipe App
//
//  Created by Jin Mizuno on 16/04/2024.
//

import Foundation
import SwiftUI

struct RecipeCardView: View {
    var imageName: String
    var recipeName: String
    
    var body: some View {
        LoadImageView(imageName: "recipes/" + imageName)
            .aspectRatio(contentMode: .fill)
            .frame(width: .infinity, height: 200)
            .clipped()
            .cornerRadius(10)
            .shadow(radius: 5)
            .overlay(
                Text(recipeName)
                    .font(.title)
                    .bold()
                    .padding(10)
                    .background(Color.black.opacity(0.7))
                    .foregroundColor(.white)
                    .cornerRadius(5),
                alignment: .bottomTrailing
            )
    }
}

struct RecipeCard_Previews: PreviewProvider {
    static var previews: some View {
        var resipe = RecipesDummyData.ToastRecipe
        RecipeCardView(imageName: resipe.imageName, recipeName: resipe.recipeName)
    }
}
