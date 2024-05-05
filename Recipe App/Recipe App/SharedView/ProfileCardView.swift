//
//  ProfileCardView.swift
//  Recipe App
//
//  Created by Jin Mizuno on 30/04/2024.
//

import Foundation
import SwiftUI

struct ProfileCardView: View {
    @State var profile: UserProfile
    
    var body: some View {
        HStack {
            LoadImageView(imageName: "profiles/" + profile.icon)
                .scaledToFill()
                .clipShape(Circle())
                .frame(width: 60, height: 60)
                .padding(.leading)
            VStack(alignment: .leading) {
                Text(profile.name)
                    .font(.headline)
            }
            .padding(.leading)
        }.padding()
    }
}

struct ProfileCardView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileCardView(profile: AuthModel(testProfile: true).profile)
    }
}
