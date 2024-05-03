//
//  Router.swift
//  Recipe App
//
//  Created by Galina Abdurashitova on 03.05.2024.
//

import Foundation
import SwiftUI

final class Router: ObservableObject {
    
    //var Destination: String
    @Published var navPath = NavigationPath()
    
    init() { }
    
    func navigate(to destination: String) {
        navPath.append(destination)
    }
    
    func navigateBack() {
        navPath.removeLast()
    }
    
    func navigateToRoot() {
        navPath.removeLast(navPath.count)
    }
}
