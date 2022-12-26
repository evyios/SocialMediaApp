//
//  ContentView.swift
//  SocialMedia
//
//  Created by Evgeny on 9.12.22.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("log_status") var logStatus: Bool = false
    var body: some View {
//        if logStatus {
//            MainView()
//        } else {
//            LoginView()
//        }
        NewPost { _ in
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
