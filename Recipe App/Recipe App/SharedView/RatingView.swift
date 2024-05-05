//
//  RatingView.swift
//  Recipe App
//
//  Created by Galina Abdurashitova on 04.05.2024.
//

import Foundation
import SwiftUI

struct RatingView: View {
    @State var rating: Double
    
    var body: some View {
        HStack {
            Image(systemName: "star.fill")
            Text(String(format: "%.1f", rating))
        }
        .foregroundColor(Color(red: 0.7, green: 0.5, blue: 0.0))
        .padding(.all, 12.0)
        .fontWeight(.bold)
        .background(Color(red: 1.0, green: 0.9, blue: 0.5))
        .cornerRadius(50.0)
        .shadow(radius: 6)
    }
}

#Preview {
    RatingView(rating: 4.864234)
}
