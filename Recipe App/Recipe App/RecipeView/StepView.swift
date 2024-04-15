//
//  StepView.swift
//  Recipe App
//
//  Created by Galina Abdurashitova on 15.04.2024.
//

import Foundation
import SwiftUI

struct StepView: View {
    @State var step: RecipeModel.Step
    
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
            
            if let stepHasImage = step.stepImage {
                Image(stepHasImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 120, height: 120)
                    .cornerRadius(10)
            }
        }
    }
}

#Preview {
    StepView(
        step: RecipeModel.Step(
            stepNumber: 1,
            description: "Use a toaster or toaster oven to toast the bread.",
            stepImage: "toastintheoven"
        )
    )
}
