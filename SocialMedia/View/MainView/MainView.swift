//
//  MainView.swift
//  SocialMedia
//
//  Created by Evgeny on 15.12.22.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            PostsView()
                .tabItem {
                    Image(systemName: "rectangle.on.rectangle")
                    Text("Post's")
                }
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person")
                    Text("Profile")
                }
        }
        .tint(.orange)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
