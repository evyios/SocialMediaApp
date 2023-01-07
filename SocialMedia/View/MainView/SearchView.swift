//
//  SearchView.swift
//  SocialMedia
//
//  Created by Evgeny on 6.01.23.
//

import SwiftUI
import FirebaseFirestore

struct SearchView: View {
    
    @State private var fetchedUsers: [User] = []
    @State private var searchText: String = ""
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(fetchedUsers) { user in
                    NavigationLink {
                        
                    } label: {
                        Text(user.username)
                            .font(.callout)
                            .hAlign(.leading)
                    }
                }
            }
            .listStyle(.plain)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Search User")
            .searchable(text: $searchText)
            .onSubmit(of: .search, {
                /// Fetching users from firebase
                Task {await searchUsers()}
            })
            .onChange(of: searchText, perform: { newValue in
                if newValue.isEmpty {
                    fetchedUsers = []
                }
            })
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .tint(.black)
                }
            }
        }
    }
    func searchUsers() async {
        do {
            let queryLowerCased = searchText.lowercased()
            let queryUpperCased = searchText.uppercased()
            
            let documents = try await Firestore.firestore().collection("Users")
                .whereField("username", isGreaterThanOrEqualTo: queryUpperCased)
                .whereField("username", isGreaterThanOrEqualTo: "\(queryLowerCased)\u{f8ff}")
                .getDocuments()
            
            let users = try documents.documents.compactMap { doc -> User? in
                try doc.data(as: User.self)
            }
            await MainActor.run(body: {
                fetchedUsers = users
            })
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
