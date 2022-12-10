//
//  RegisterView.swift
//  SocialMedia
//
//  Created by Evgeny on 10.12.22.
//

import SwiftUI
import PhotosUI

struct RegisterView: View {
    
    @State var emailID: String = ""
    @State var password: String = ""
    @State var userName: String = ""
    @Environment(\.dismiss) var dismiss
    
    @State var userBio: String = ""
    @State var userBioLink: String = ""
    @State var userProfilePicData: Data?
    
    @State var showImagePicker: Bool = false
    @State var photoItem: PhotosPickerItem?
    
    var body: some View {
        VStack(spacing: 10) {
            Text("Register Account")
                .font(.largeTitle.bold())
                .hAlign(.leading)
                .padding(.bottom,20)
            
            
            //MARK: Smaller size optimization
            ViewThatFits {
                ScrollView(.vertical, showsIndicators: false) {
                    HelperView()
                }
                HelperView()
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
        .photosPicker(isPresented: $showImagePicker, selection: $photoItem)
        .onChange(of: photoItem) { newValue in
            if let newValue {
                Task {
                    do {
                        guard let imageData = try await newValue.loadTransferable(type: Data.self) else {return}
                        await MainActor.run(body: {
                            userProfilePicData = imageData
                        })
                    } catch {
                        
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    func HelperView() -> some View {
        VStack(spacing: 15) {
            
            ZStack {
                if let userProfilePicData, let image = UIImage(data: userProfilePicData) {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipShape(Circle())
                } else {
                    Image(systemName: "person.crop.circle.fill.badge.plus")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .symbolRenderingMode(.multicolor)
                    
                }
            }
            .frame(width: 85, height: 85)
            .contentShape(Circle())
            .onTapGesture {
                showImagePicker.toggle()
            }
            
            TextField("Username", text: $userName)
                .textContentType(.emailAddress)
                .border(2, .gray.opacity(0.7))
                .padding(.top,20)
            
            TextField("Email", text: $emailID)
                .textContentType(.emailAddress)
                .border(2, .gray.opacity(0.7))
                .padding(.top,25)
            
            SecureField("Password", text: $password)
                .textContentType(.emailAddress)
                .border(2, .gray.opacity(0.7))
            
            TextField("About You", text: $userBio, axis: .vertical)
                .frame(minHeight: 100, alignment: .top)
                .textContentType(.emailAddress)
                .padding(.horizontal,15)
                .padding(.vertical,10)
                .background {
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.gray, lineWidth: 2)
                }
            
            TextField("Bio Link (Optional)", text: $userBioLink)
                .textContentType(.emailAddress)
                .border(2, .gray.opacity(0.7))
    
            
            Button {
                
            } label: {
                Text("Sign up")
                    .foregroundColor(.white)
                    .hAlign(.center)
                    .fillView(.black)
            }
            .padding(.top,50)

        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
