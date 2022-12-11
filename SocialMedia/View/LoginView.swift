//
//  LoginView.swift
//  SocialMedia
//
//  Created by Evgeny on 10.12.22.
//

import SwiftUI
import Firebase

struct LoginView: View {
    
    @State var emailID: String = ""
    @State var password: String = ""
    
    @State var createAccount: Bool = false
    
    @State var showError: Bool = false
    @State var errorMassage: String = ""
    
    var body: some View {
        VStack(spacing: 10) {
            Text("Let's Sign you in")
                .font(.largeTitle.bold())
                .hAlign(.leading)
            
            Text("Welcome back, \nYou have been missed")
                .font(.title3)
                .hAlign(.leading)
            
            VStack(spacing: 15) {
                TextField("Email", text: $emailID)
                    .textContentType(.emailAddress)
                    .border(2, .gray.opacity(0.7))
                    .padding(.top,25)
                
                SecureField("Password", text: $password)
                    .textContentType(.emailAddress)
                    .border(2, .gray.opacity(0.7))
                
                Button("Reset Password?", action: resetPassword)
                    .font(.callout)
                    .fontWeight(.medium)
                    .tint(.black)
                    .hAlign(.trailing)
                
                Button(action: loginUser) {
                    Text("Sign in")
                        .foregroundColor(.white)
                        .hAlign(.center)
                        .fillView(.black)
                }
                .padding(.top,25)

            }
            
            HStack(spacing: 15) {
                Text("Don't have an account?")
                    .foregroundColor(.gray)
                
                Button("Register Now") {
                    createAccount.toggle()
                }
                .fontWeight(.bold)
                .foregroundColor(.black)
            }
            .font(.callout)
            .vAlign(.bottom)
        }
        .vAlign(.top)
        .padding(15)
        // MARK: Register View
        .fullScreenCover(isPresented: $createAccount) {
            RegisterView()
        }
        .alert(errorMassage, isPresented: $showError) {
            
        }
    }
    func loginUser() {
        Task {
            do {
                try await Auth.auth().signIn(withEmail: emailID, password: password)
                print("User Found")
            } catch {
                await setError(error)
            }
        }
    }
    
    func resetPassword() {
        Task {
            do {
                try await Auth.auth().sendPasswordReset(withEmail: emailID)
                print("Link Sent")
            } catch {
                await setError(error)
            }
        }

    }
    
    //MARK: Displaying errors via alerts
    func setError(_ error: Error) async {
        //MARK: Updating UI on main thread
        await MainActor.run(body: {
            errorMassage = error.localizedDescription
            showError.toggle()
        })
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

extension View {
    func hAlign(_ alignment: Alignment) -> some View {
        self
            .frame(maxWidth: .infinity, alignment: alignment)
    }
    
    func vAlign(_ alignment: Alignment) -> some View {
        self
            .frame(maxHeight: .infinity, alignment: alignment)
    }
    
    func border(_ width: CGFloat, _ color: Color) -> some View {
        self
            .padding(.horizontal,15)
            .padding(.vertical,10)
            .background {
                Capsule(style: .continuous)
                    .stroke(color, lineWidth: width)
            }
    }
    
    func fillView(_ color: Color) -> some View {
        self
            .padding(.horizontal,15)
            .padding(.vertical,10)
            .background {
                Capsule(style: .continuous)
                    .fill(color)
            }
    }
}
