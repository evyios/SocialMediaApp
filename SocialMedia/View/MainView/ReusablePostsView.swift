//
//  ReusablePostsView.swift
//  SocialMedia
//
//  Created by Evgeny on 31.12.22.
//

import SwiftUI
import Firebase

struct ReusablePostsView: View {
    
    @Binding var posts: [Post]
    
    var basedOnUID: Bool = false
    var uid: String = ""
    
    @State private var isFetching: Bool = true
    
    @State private var paginationDoc: QueryDocumentSnapshot?
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack {
                if isFetching {
                    ProgressView()
                        .padding(.top,30)
                } else {
                    if posts.isEmpty {
                        Text("No Post's Found")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding(.top,30)
                    } else {
                        Posts()
                    }
                }
            }
            .padding(15)
        }
        .refreshable {
            guard !basedOnUID else {return}
            isFetching = true
            posts = []
            paginationDoc = nil
            await fetchPosts()
        }
        .task {
            guard posts.isEmpty else {return}
            await fetchPosts()
        }
    }
    /// Displaying Fetching Post's
    @ViewBuilder
    func Posts() -> some View {
        ForEach(posts) { post in
            PostCardView(post: post) { updatedPost in
                /// Updating post in the array
                if let index = posts.firstIndex(where: { post in
                    post.id == updatedPost.id
                }) {
                    posts[index].likedIDs = updatedPost.likedIDs
                    posts[index].dislikedIDs = updatedPost.dislikedIDs
                }
            } onDelete: {
                /// Removing post from the array
                withAnimation(.easeInOut(duration: 0.25)) {
                    posts.removeAll {post.id == $0.id}
                }
            }
            .onAppear {
                if post.id == posts.last?.id && paginationDoc != nil {
                    Task{await fetchPosts()}
                }
            }
            
            Divider()
                .padding(.horizontal,-15)
        }
    }
    /// Fetching post's
    func fetchPosts() async {
        do {
            var query: Query!
            
            if let paginationDoc {
                query = Firestore.firestore().collection("Posts")
                    .order(by: "publishedDate", descending: true)
                    .start(afterDocument: paginationDoc)
                    .limit(to: 20)
            } else {
                query = Firestore.firestore().collection("Posts")
                    .order(by: "publishedDate", descending: true)
                    .limit(to: 20)
            }
            
            let docs = try await query.getDocuments()
            let fetchedPosts = docs.documents.compactMap { doc -> Post? in
                try? doc.data(as: Post.self)
            }
            
            if basedOnUID {
                query = query
                    .whereField("userUID", isEqualTo: uid)
            }
            
            await MainActor.run(body: {
                posts.append(contentsOf: fetchedPosts)
                paginationDoc = docs.documents.last
                isFetching = false
            })
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct ReusablePostsView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
