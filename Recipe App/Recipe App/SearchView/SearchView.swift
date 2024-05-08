//
//  SearchView.swift
//  Recipe App
//
//  Created by Reza on 1/5/24.
//

import Foundation
import SwiftUI

struct SearchView: View {
    @ObservedObject var searchViewModel: SearchViewModel
    @ObservedObject var auth: AuthModel
    
    init(recipes: [RecipeModel], auth: AuthModel) {
        self.auth = auth
        self.searchViewModel = SearchViewModel(recipes: recipes)
    }
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("Search")
                .font(.title)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
            
            Spacer()
            
            HStack {
                Text("Sorting")
                Spacer()
            }
            Picker(selection: $searchViewModel.selectedTimeFilter, label: Text("")) {
                Text("All").tag("All")
                Text("Newest").tag("Newest")
                Text("Oldest").tag("Oldest")
                Text("Popularity").tag("Popularity")
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            HStack {
                Text("Rating")
                Spacer()
            }
            Picker(selection: $searchViewModel.selectedRatingFilter, label: Text("")) {
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
            Picker(selection: $searchViewModel.selectedCategoryFilter, label: Text("")) {
                Text("All").tag(nil as Category?)
                ForEach(Category.allCases, id: \.self) { category in
                    Text(category.rawValue).tag(category as Category?)
                }
            }
            .pickerStyle( WheelPickerStyle())
            .padding()
            
            CustomTextField(label: "Recipe Name", placeHolder: "Search by Name", text: $searchViewModel.searchText)
                .padding()
            
            Spacer()
            
            NavigationLink(destination: FilteredRecipesView(searchViewModel: searchViewModel, auth: auth)) {
                ButtonView(text: "Filter", color: Color.blue)
            }
        }
        .navigationTitle("")
        .padding()
    }
}


struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        return SearchView(recipes: RecipesDummyData.recipes, auth: AuthModel(testProfile: true))
    }
}
