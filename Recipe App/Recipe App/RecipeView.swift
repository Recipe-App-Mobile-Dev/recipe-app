//
//  RecipeView.swift
//  Recipe App
//
//  Created by Galina Abdurashitova on 08.04.2024.
//

import Foundation
import SwiftUI

struct RecipeView: View {
    var body: some View {
        ScrollView {
            Text("Toasts")
                .font(.largeTitle)
                .bold()
            Image("toasts")
                //.resizable()
                .frame(width: 350, height: 300)
                .cornerRadius(10)
            
            HStack {
                Text("Procedures")
                    .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                    .padding()
                Spacer()
            }
            
            HStack {
                Text("Step 1")
                    .multilineTextAlignment(.leading)
                    .padding()
                Spacer()
            }
            
            Text("Lorem Ipsum tempor incididunt ut labore et dolore,in voluptate velit esse cillum dolore eu fugiat nulla pariatur? Lorem Ipsum tempor incididunt ut labore et dolore,in voluptate velit esse cillum dolore eu fugiat nulla pariatur?")
                .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                .padding()
            
            HStack {
                Text("Ingridients")
                    .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                    .padding()
                Spacer()
            }
            
            HStack {
                Image("Tomato")
                    .resizable()
                    .frame(width: 65, height: 65)
                    .cornerRadius(10)
                Text("Tomatoes")
                Spacer()
                Text("500g")
            }
            .padding()
        }
    }
}

#Preview {
    RecipeView()
}
