//
//  UserProfile.swift
//  Recipe App
//
//  Created by Jin Mizuno on 27/04/2024.
//

import Foundation

struct UserProfile: Codable, Hashable {
    var uid: String
    var name: String
    var icon: String
}
