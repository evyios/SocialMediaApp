//
//  RegisterView.swift
//  SocialMedia
//
//  Created by Evgeny on 10.12.22.
//

import SwiftUI

struct RegisterView: View {
    
    @State var emailID: String = ""
    @State var password: String = ""
    @State var userName: String = ""
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 10) {
            Text("Let's Sign you in")
                .font(.largeTitle.bold())
                .hAlign(.leading)
            
            Text("Welcome back, \nYou have been missed")
                .font(.title3)
                .hAlign(.leading)
            
            VStack(spacing: 15) {
                
                TextField("Username", text: $userName)
                    .textContentType(.emailAddress)
                    .border(2, .gray.opacity(0.7))
                    .padding(.top,25)
                
                TextField("Email", text: $emailID)
                    .textContentType(.emailAddress)
                    .border(2, .gray.opacity(0.7))
                    .padding(.top,25)
                
                SecureField("Password", text: $password)
                    .textContentType(.emailAddress)
                    .border(2, .gray.opacity(0.7))
        
                
                Button {
                    
                } label: {
                    Text("Sign up")
                        .foregroundColor(.white)
                        .hAlign(.center)
                        .fillView(.black)
                }
                .padding(.top,25)

            }
            
            HStack(spacing: 15) {
                Text("Already have an account?")
                    .foregroundColor(.gray)
                
                Button("Login") {
                    dismiss()
                }
                .fontWeight(.bold)
                .foregroundColor(.black)
            }
            .font(.callout)
            .vAlign(.bottom)
        }
        .vAlign(.top)
        .padding(15)
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
