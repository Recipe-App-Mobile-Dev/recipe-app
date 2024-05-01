//
//  LoadImageView.swift
//  Recipe App
//
//  Created by Galina Abdurashitova on 28.04.2024.
//

import Foundation
import SwiftUI

struct LoadImageView: View {
    let imageName: String
    @State private var isLoading = true
    @State private var loadedImage: Image?
    var imagesRepository = ImagesRepository()

    var body: some View {
        VStack {
            if isLoading {
                ProgressView()
            } else {
                if let image = loadedImage {
                    image
                        .resizable()
                }
            }
        }
        .onAppear {
            loadImage()
        }
    }
    
    func loadImage() {
        imagesRepository.getImage(name: imageName) { image in
            DispatchQueue.main.async {
                loadedImage = image // Update the loaded image
                isLoading = false
            }
        }
    }
}

#Preview {
    LoadImageView(imageName: "recipes/toasts.jpg")
            .aspectRatio(contentMode: .fill)
            .frame(width: 300, height: 300)
            .cornerRadius(10)
}
