//
//  StepView.swift
//  Recipe App
//
//  Created by Galina Abdurashitova on 15.04.2024.
//

import Foundation
import SwiftUI

struct StepView: View {
    @State var recipeId: String
    @Binding var step: RecipeModel.Step
    @Binding var isRefreshing: Bool
    
    var body: some View {
        HStack {
            VStack {
                Text("Step " + String(step.stepNumber))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.title3)
                    .padding(.bottom, 3.0)
                
                Text(step.description)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(Color(.darkGray))
            }
            
            if let stepHasImage = step.stepImage, stepHasImage != "" {
                LoadImageView(imageName: stepHasImage, reloadTrigger: isRefreshing)
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 120, height: 120)
                    .cornerRadius(10)
            }
        }
    }
}

#Preview {
    StepView(
        recipeId: "kIBFyJd7Rotf5bXJt18A",
        step: Binding<RecipeModel.Step> (
            get: { return RecipeModel.Step(
                stepNumber: 1,
                description: "Use a toaster or toaster oven to toast the bread.",
                stepImage: "toastintheoven.jpg"
            ) },
            set: { _ in }
        ),
        isRefreshing: Binding<Bool> (
            get: { return false },
            set: { _ in }
        )
    )
}
