//
//  PostCardView.swift
//  SocialMedia
//
//  Created by Evgeny on 31.12.22.
//

import SwiftUI
import SDWebImageSwiftUI
import Firebase
import FirebaseStorage

struct PostCardView: View {
    
    var post: Post
    
    var onUpdate: (Post) -> ()
    var onDelete: () -> ()
    
    @AppStorage("user_UID") private var userUID: String = ""
    
    /// For live updates
    @State private var docListner: ListenerRegistration?
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            WebImage(url: post.userProfileURL)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 35, height: 35)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 6) {
                Text(post.username)
                    .font(.callout)
                    .fontWeight(.semibold)
                Text(post.publishedDate.formatted(date: .numeric, time: .shortened))
                    .font(.caption2)
                    .foregroundColor(.gray)
                Text(post.text)
                    .textSelection(.enabled)
                    .padding(.vertical,8)
                
                if let postImageURL = post.imageURL {
                    GeometryReader {
                        let size = $0.size
                        WebImage(url: postImageURL)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: size.width, height: size.height)
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    }
                    .frame(height: 200)
                }
                PostInteraction()
            }
        }
        .hAlign(.leading)
        .overlay(alignment: .topTrailing,  content: {
            if post.userUID == userUID {
                Menu {
                    Button("Delete Post", role: .destructive, action: deletingPost)
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.caption)
                        .rotationEffect(Angle(degrees: -90))
                        .foregroundColor(.black)
                        .padding(8)
                        .contentShape(Rectangle())
                }
                .offset(x: 8)
            }
        })
        .onAppear {
            if docListner == nil {
                guard let postID = post.id else {return}
                docListner = Firestore.firestore().collection("Posts").document(postID).addSnapshotListener({ snapshot, error in
                    if let snapshot {
                        if snapshot.exists {
                            if let updatedPost = try? snapshot.data(as: Post.self) {
                                onUpdate(updatedPost)
                            }
                        } else {
                            onDelete()
                        }
                    }
                })
            }
        }
        .onDisappear {
            if let docListner {
                docListner.remove()
                self.docListner = nil
            }
        }
    }
    
    @ViewBuilder
    func PostInteraction() -> some View {
        HStack(spacing: 6) {
            Button {
                likedPost()
            } label: {
                Image(systemName: post.likedIDs.contains(userUID) ? "hand.thumbsup.fill" : "hand.thumbsup")
            }
            
            Text("\(post.likedIDs.count)")
                .font(.caption)
                .foregroundColor(.gray)

            Button {
                dislikedPost()
            } label: {
                Image(systemName: post.dislikedIDs.contains(userUID) ? "hand.thumbsdown.fill" : "hand.thumbsdown")
            }
            .padding(.leading,25)
            
            Text("\(post.dislikedIDs.count)")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .foregroundColor(.black)
        .padding(.vertical,8)
    }
    
    func likedPost() {
        Task {
            guard let postID = post.id else {return}
            if post.likedIDs.contains(userUID) {
                /// Removing user id from tha array
              try await Firestore.firestore().collection("Posts").document(postID).updateData(["likedIDs": FieldValue.arrayRemove([userUID])])
            } else {
                /// Adding user id to liked array and removing from disliked
                try await Firestore.firestore().collection("Posts").document(postID).updateData(["likedIDs": FieldValue.arrayUnion([userUID]), "dislikedIDs": FieldValue.arrayRemove([userUID])])
            }
        }
    }
    
    func dislikedPost() {
        Task {
            guard let postID = post.id else {return}
            if post.dislikedIDs.contains(userUID) {
               try await Firestore.firestore().collection("Posts").document(postID).updateData(["dislikedIDs": FieldValue.arrayRemove([userUID])])
            } else {
                try await Firestore.firestore().collection("Posts").document(postID).updateData(["likedIDs": FieldValue.arrayRemove([userUID]), "dislikedIDs": FieldValue.arrayUnion([userUID])])
            }
        }
    }
    
    func deletingPost() {
        Task {
            /// 1. Delete image from storage if present
            do {
                if post.imageReferenceId != "" {
                    try await Storage.storage().reference().child("Post_Images").child(post.imageReferenceId).delete()
                }
                /// 2. Delete Firestore document
                guard let postID = post.id else {return}
                try await Firestore.firestore().collection("Posts").document(postID).delete()
            } catch {
                print(error.localizedDescription)
            }
        }
    }

}
