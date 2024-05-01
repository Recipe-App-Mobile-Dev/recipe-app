//
//  SearchView.swift
//  Recipe App
//
//  Created by Reza on 1/5/24.
//

import Foundation
import SwiftUI
struct Recipe: Identifiable {
    var id = UUID()
    var name: String
    var category: String
    var rating: Int
    var time: String
}
struct SearchView: View {
    @ObservedObject var searchModel: SearchModel
    
    let categories = ["All", "Cereal", "Vegetables", "Dinner", "Chinese", "Local Dish", "Fruit", "Breakfast", "Spanish", "Italian", "Lunch"]
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                Text("Search")
                    .font(.title)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                
                Spacer()
                
                HStack {
                    Text("Time")
                    Spacer()
                }
                Picker(selection: $searchModel.selectedTimeFilter, label: Text("")) {
                    Text("All").tag("All")
                    Text("Newest").tag("Newest")
                    Text("Oldest").tag("Oldest")
                    Text("Popularity").tag("Popularity")
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                HStack {
                    Text("Rate")
                    Spacer()
                }
                Picker(selection: $searchModel.selectedRatingFilter, label: Text("")) {
                    Text("All").tag("All")
                    ForEach(1...5, id: \.self) { rating in
                        Text("\(rating)★").tag("\(rating)")
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                HStack {
                    Text("Category")
                    Spacer()
                }
                Picker(selection: $searchModel.selectedCategoryFilter, label: Text("")) {
                    ForEach(categories, id: \.self) { category in
                        Text(category)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .padding()
                
                HStack {
                    Text("Name")
                    Spacer()
                }
                TextField("Search by Name", text: $searchModel.searchText)
                    .padding()
                
                Spacer()
                
                NavigationLink(destination: FilteredRecipesView(searchModel: searchModel)) {
                    Text("Filter")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(Color.white)
                        .cornerRadius(10)
                }
                .padding()
            }
            .navigationTitle("")
            .navigationBarHidden(true) // Hide the default navigation bar
        }
    }
}
struct FilteredRecipesView: View {
    @ObservedObject var searchModel: SearchModel
    
    var body: some View {
        List(searchModel.filterRecipes()) { recipe in
            Text(recipe.name)
        }
        .navigationTitle("Filtered Recipes")
    }
}
struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        let searchModel = SearchModel()
        return SearchView(searchModel: searchModel)
    }
}
