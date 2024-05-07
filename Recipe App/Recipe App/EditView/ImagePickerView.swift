//
//  ImagePickerView.swift
//  Recipe App
//
//  Created by Galina Abdurashitova on 07.05.2024.
//

import Foundation
import SwiftUI

struct ImagePickerView: View {
    @State var imageName: String?
    @Binding var loadImage: UIImage?
    
    var body: some View {
        if let image = loadImage {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .overlay(
                    Group {
                        Color.black.opacity(0.3)
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.white)
                            .opacity(0.5)
                            .frame(width: 100, height: 100)
                    }
                )
        } else {
            if let image = imageName {
                LoadImageView(imageName: image)
                    .aspectRatio(contentMode: .fill)
                    .overlay(
                        Group {
                            Color.black.opacity(0.3)
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.white)
                                .opacity(0.5)
                                .frame(width: 100, height: 100)
                        }
                    )
            } else {
                ZStack {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                }
            }
        }
    }
}

//#Preview {
//    ImagePickerView(imageName: "recipes/toasts.jpg", loadImage: (
//        recipe: Binding<UIImage?> (
//            get: { return UIImage(nil)? },
//            set: { _ in }
//        ))
//        .frame(width: UIScreen.main.bounds.width * 0.6, height: 300)
//        .cornerRadius(10)
//        .padding()
//}
