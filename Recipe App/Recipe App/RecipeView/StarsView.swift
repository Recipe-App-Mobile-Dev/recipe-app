//
//  StarsView.swift
//  Recipe App
//
//  Created by Galina Abdurashitova on 04.05.2024.
//

import Foundation
import SwiftUI

struct StarsView: View {
    @Binding var stars: Int?
    @State var allowRate: Bool = true
    
    var body: some View {
        HStack {
            ForEach(1...5, id: \.self) { i in
                Image(systemName: i <= stars ?? 0 ? "star.fill" : "star")
                    .foregroundColor(i <= stars ?? 0 ? .yellow : .gray)
                    .fontWeight(.bold)
                    .onTapGesture {
                        if allowRate {
                            stars = i
                        }
                    }
            }
        }
        .padding()
    }
}

#Preview {
    StarsView(
        stars: Binding<Int?>(
            get: { return 4 },
            set: { _ in }
        ),
        allowRate: true
    )
}
