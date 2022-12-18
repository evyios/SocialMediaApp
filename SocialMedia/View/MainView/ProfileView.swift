//
//  ProfileView.swift
//  SocialMedia
//
//  Created by Evgeny on 15.12.22.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseStorage

struct ProfileView: View {
    
    @State private var myProfile: User?
    @AppStorage("log_status") var logStatus: Bool = false
    
    @State var errorMessage: String = ""
    @State var showError: Bool = false
    
    @State var isLoading: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                if let myProfile {
                    ProfileInfo(user: myProfile)
                } else {
                    ProgressView()
                }
            }
            .refreshable {
                self.myProfile = nil
                await fetchUserData()
            }
            .navigationTitle("My profile")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        //MARK: 2 Actions: Logout and Delete Account
                        Button("Logout", action: logOutUser)
                        
                        Button("Delete Account", role: .destructive, action: deleteAccount)
                        
                    } label: {
                        Image(systemName: "ellipsis")
                            .rotationEffect(.init(degrees: 90))
                            .tint(.black)
                            .scaleEffect(0.9)
                    }
                }
            }
        }
        .overlay {
            LoadingView(show: $isLoading)
        }
        .alert(errorMessage, isPresented: $showError) {
            
        }
        .task {
            if myProfile != nil {return}
            await fetchUserData()
        }
    }
    
    func fetchUserData() async {
        guard let userUID = Auth.auth().currentUser?.uid else {return}
        guard let user = try? await Firestore.firestore().collection("Users").document(userUID).getDocument(as: User.self) else {return}
        await MainActor.run(body: {
            myProfile = user
        })
    }
    
    func logOutUser() {
        try? Auth.auth().signOut()
        logStatus = false
    }
    func deleteAccount() {
        Task {
            do {
                guard let userUID = Auth.auth().currentUser?.uid else { return }
                
                // 1. Deleting profile image from storage
                let reference = Storage.storage().reference().child("Profile_Images").child(userUID)
                try await reference.delete()
                // 2. Deleting Firestore user document
                try await Firestore.firestore().collection("Users").document(userUID).delete()
                // 3. Deleting Auth account and setting log status to false
                try await Auth.auth().currentUser?.delete()
                logStatus = false
                
            } catch {
                await setError(error)
            }
        }
    }
    func setError(_ error: Error) async {
        await MainActor.run(body: {
            errorMessage = error.localizedDescription
            showError.toggle()
        })
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
