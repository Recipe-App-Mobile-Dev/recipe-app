//
//  ContentView.swift
//  AddRecipeView
//
//  Created by Charlene on 16/04/2024.
//

import SwiftUI
import UIKit

struct AddRecipeView: View {
    @State private var name: String = ""
    @State private var category: String = ""
    @State private var description: String = ""
    @State private var ingredients: String = ""
    @State private var direction: String = ""
    @State private var image: Image?
    @State private var isShowingImagePicker = false
    @State private var addingredients: [String] = []
    @State private var procedures: [String] = []

    @Environment(\.dismiss)var dismiss
    
    var body: some View {
        NavigationView{
            Form{
                Section(header: Text("Name")){
                    TextField("Recip Name", text: $name)
                }
                Section(header: Text("Image")) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.clear, lineWidth: 0)
                        VStack {
                            if let _ = image {
                                image?
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                            } else {
                                Image(systemName: "photo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                                    .foregroundColor(.blue)
                            }
                            Button(action: {
                                isShowingImagePicker = true
                            }) {
                                Text("Add Image")
                            }
                        }
                    }
                }
                Section(header: Text("Description")){
                    TextEditor(text:$description)
                }
                Section(header: Text("Ingredients")){
                    ForEach(addingredients.indices, id: \.self) { index in
                        Text("Ingredient \(index + 1)")
                        TextEditor(text:$addingredients[index])
                    }
                    Button(action: {
                        addIngredient()
                    }) {
                        Text("Add Ingredient")
                    }
                }
                Section(header: Text("Directions")) {
                    ForEach(procedures.indices, id:\.self) { index in
                        Text("Step \(index + 1)")
                        TextEditor(text: $procedures[index])
                    }
                    Button(action: {
                        addProcedure()
                    }) {
                        Text("Add Procedure")
                    }
                }
            }
            .navigationTitle("New Recipe")
            .navigationBarTitleDisplayMode(.inline)
//            .navigationBarItems(trailing: Button("Done") {
//                        dismiss()
//                    })
            .toolbar {
                        ToolbarItem(placement: .bottomBar) {
                            Button("Done") {
                                dismiss()
                            }
                        }
                    }
            .fileImporter(
                isPresented: $isShowingImagePicker,
                allowedContentTypes: [.image],
                allowsMultipleSelection: false
            ) { result in
                do {
                    guard let selectedImage = try result.get().first else { return }
                    guard let imageData = try? Data(contentsOf: selectedImage) else { return }
                    guard let uiImage = UIImage(data: imageData) else { return }
                    image = Image(uiImage: uiImage)
                } catch {
                    print("Error selecting image: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func addProcedure() {
        procedures.append("")
    }
    private func addIngredient() {
        addingredients.append("")
    }
}
struct AddRecipeView_Previews: PreviewProvider {
    static var previews: some View {
        AddRecipeView()
    }
}
