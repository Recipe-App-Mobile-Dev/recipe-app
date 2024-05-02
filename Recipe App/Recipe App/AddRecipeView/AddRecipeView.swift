//
//  ContentView.swift
//  AddRecipeView
//
//  Created by Charlene on 16/04/2024.
//

import SwiftUI
import UIKit

struct IngredientData {
    var image: Image?
    var isShowingImagePicker: Bool
    var textInput: String
}

struct AddRecipeView: View {
    @State private var name: String = ""
    @State private var category: String = ""
    @State private var description: String = ""
    @State private var ingredients: String = ""
    @State private var ingredientRows: [[IngredientData]] = [[]]
    @State private var direction: String = ""
    @State private var image: Image?
    @State private var isShowingImagePicker = false
    @State private var addingredients: [String] = []
    @State private var textInput: String = ""
    @State private var showNextRow = false
    @State private var procedures: [String] = []
    @State private var selectedCategories: [Category] = []

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
                    ForEach(ingredientRows.indices, id:\.self) { rowIndex in
                        Grid(alignment: .topTrailing, horizontalSpacing: 20) {
                            GridRow {
                                VStack {
                                    image?
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 100, height: 100)
                                        .padding()
                                    
                                    Button(action: {
                                        isShowingImagePicker = true
                                    }) {
                                        Text("Upload Image")
                                            .foregroundStyle(.cyan)
                                        
                                    }
                                }
                                .overlay(
                                    RoundedRectangle(cornerRadius: 6)
                                        .stroke(.blue, lineWidth: 2)
                                )
                                .padding()
                                
                                VStack {
                                    TextField("Enter text", text: $textInput)
                                        .padding()
                                }
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(.blue, lineWidth: 2)
                                )
                                .padding()
                                
                                VStack {
                                    TextField("Enter text", text: $textInput)
                                        .padding()
                                }
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(.blue, lineWidth: 2)
                                )
                                .padding()
                            }
                            
                            if showNextRow {
                                GridRow{
                                    VStack {
                                        image?
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 100, height: 100)
                                            .padding()
                                        
                                        Button(action: {
                                            isShowingImagePicker = true
                                        }) {
                                            Text("Upload Image")
                                                .foregroundStyle(.cyan)
                                            
                                        }
                                    }
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 6)
                                            .stroke(.blue, lineWidth: 2)
                                    )
                                    .padding()
                                    
                                    VStack {
                                        TextField("Name", text: $textInput)
                                            .padding()
                                    }
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(.blue, lineWidth: 2)
                                    )
                                    .padding()
                                    
                                    VStack {
                                        TextField("Amount", text: $textInput)
                                            .padding()
                                    }
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(.blue, lineWidth: 2)
                                    )
                                    .padding()
                                }
                            }
                        }
                    }
                    Button(action: {
                        addIngredientRow()
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
                Section(header: Text("Categories")){
                    ScrollView(.horizontal, showsIndicators:false){
                        LazyHGrid(rows: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 10){
                            ForEach(Category.allCases){
                                category in
                                Button(action: {
                                    toggleCategorySelection(category)
                                }) {
                                    Text(category.rawValue)
                                        .foregroundColor(selectedCategories.contains(category) ? .white : .blue)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 5)
                                        .background(selectedCategories.contains(category) ? Color.blue : Color.white)
                                        .cornerRadius(10)
                                }
                            }
                        }
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
    private func addIngredientRow() {
        var newRow: [IngredientData] = []
            for _ in 0..<3 {
                newRow.append(IngredientData(image: nil, isShowingImagePicker: false, textInput: ""))
            }
            ingredientRows.append(newRow)
    }
    private func toggleCategorySelection(_ category: Category){
        if selectedCategories.contains(category) {
            selectedCategories.removeAll{ $0 == category }
        } else {
            selectedCategories.append(category)
        }
    }
}
struct AddRecipeView_Previews: PreviewProvider {
    static var previews: some View {
        AddRecipeView()
    }
}
