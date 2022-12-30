//
//  PostsView.swift
//  SocialMedia
//
//  Created by Evgeny on 30.12.22.
//

import SwiftUI

struct PostsView: View {
    
    //@State private var recentsPosts: [Post] = []
    @State private var createNewPost: Bool = false
    
    var body: some View {
        NavigationStack {
            //ReusablePostsView(posts: $recentsPosts)
            Text("hello")
                .hAlign(.center).vAlign(.center)
                .overlay(alignment: .bottomTrailing) {
                    Button {
                        createNewPost.toggle()
                    } label: {
                        Image(systemName: "plus")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding(13)
                            .background(.black, in: Circle())
                    }
                    .padding(15)
                }
                .navigationTitle("Post's")
        }
        .fullScreenCover(isPresented: $createNewPost) {
            NewPost { post in
                /// Adding created posts at the top of the recent posts
                //recentsPosts.insert(post, at: 0)
            }
        }
    }
}

struct PostsView_Previews: PreviewProvider {
    static var previews: some View {
        PostsView()
    }
}
