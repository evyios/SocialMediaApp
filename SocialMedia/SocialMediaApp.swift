//
//  SocialMediaApp.swift
//  SocialMedia
//
//  Created by Evgeny on 9.12.22.
//

import SwiftUI
import Firebase

@main
struct SocialMediaApp: App {
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
