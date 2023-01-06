//
//  Post.swift
//  SocialMedia
//
//  Created by Evgeny on 26.12.22.
//

import SwiftUI
import FirebaseFirestoreSwift

struct Post: Identifiable, Codable, Equatable, Hashable {
    @DocumentID var id: String?
    var text: String
    var imageURL: URL?
    var imageReferenceId: String = ""
    var publishedDate: Date = Date()
    var likedIDs: [String] = []
    var dislikedIDs: [String] = []
    
    var username: String
    var userUID: String
    var userProfileURL: URL
    
    enum CodingKeys: CodingKey {
        case id
        case text
        case imageURL
        case imageReferenceId
        case publishedDate
        case likedIDs
        case dislikedIDs
        case username
        case userUID
        case userProfileURL
    }
}


