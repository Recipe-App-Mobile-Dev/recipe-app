//
//  CategoryView.swift
//  Recipe App
//
//  Created by Galina Abdurashitova on 04.05.2024.
//

import Foundation
import SwiftUI

struct CategoryView: View {
    @State var category: Category
    
    var body: some View {
        HStack{
            Image(category.rawValue)
                .resizable()
                .frame(width: 17, height: 17)
                .padding(.all, 5.0)
                .background(Color(red: 0.2, green: 0.65, blue: 0.2))
                .cornerRadius(50.0)
            Text(category.rawValue)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(Color(red: 0.2, green: 0.65, blue: 0.2))
        }
        .padding(.horizontal, 8.0)
        .padding(.vertical, 4.0)
        .background(Color.white)
        .cornerRadius(5.0)
        .overlay(
            RoundedRectangle(cornerRadius: 7.0)
                .stroke(Color(red: 0.2, green: 0.65, blue: 0.2), lineWidth: 1.0)
        )
    }
}

#Preview {
    CategoryView(category: Category.salad)
}
