//
//  MainMessagesView.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 3/30/23.
//

import SwiftUI

struct MainMessagesView: View {
    @StateObject private var mainMessagesVM = MainMessagesViewModel()
    
    var body: some View {
        NavigationStack {
            
            VStack {
                mainMessagesCustomNavBar
                messagesScrollView
//                newMessageView
            }.navigationBarHidden(true)
        }
    }
    
    private var messagesScrollView: some View {
        ScrollView {
            ForEach(0..<10, id: \.self) { num in
                VStack {
                    HStack(spacing: 16){
                        messengerProfileImage
                        VStack(alignment: .leading) {
                            Text("UserName")
                                .font(.roboto(.bold, size: 16))
                            Text("messages sent to user")
                                .font(.roboto(.semibold, size: 14))
                                .foregroundColor(.lightGrey)
                        }
                        Spacer()
                        Text("22d")
                            .font(.roboto(.semibold, size: 15))
                    }
                    Divider()
                        .padding(.vertical, 8)
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
            }
            .padding(.bottom, 50)
        }
    }
    
    private var messengerProfileImage: some View {
        Image(systemName: "person.fill")
            .font(.system(size: 32))
            .padding(8)
            .overlay(RoundedRectangle(cornerRadius: 44)
                .stroke( .black,
                       lineWidth: 1)
            )
            .scaledToFit()
            .frame(width: 32, height: 32)
    }
    
    private var mainMessagesCustomNavBar: some View {
        HStack (spacing: 16){
            profileImageView
//                        .font(.system(size: 34, weight: .heavy))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(mainMessagesVM.user.displayName ?? "")
                    .font(.roboto(.bold, size: 24))
                HStack {
                    Circle()
                        .foregroundColor(.green)
                        .frame(width: 14, height: 14)
                    Text("Online")
                        .font(.roboto(.semibold, size: 12))
                        .foregroundColor(.lightGrey)
                }

                
            }
            Spacer()
            gearButtonView
        }
        .padding()
    }
    
    private var gearButtonView: some View {
        Button {
            // takes you to friend's list maybe? idk. stand by.
        } label: {
            Image(systemName: "gear")
        }

    }
    
    private var profileImageView: some View {
        VStack {
            //            if let profileImage = mainMessagesVM.profileImage {
            Image(uiImage: (mainMessagesVM.profileImage ?? UIImage(named: "WantedWizard+"))!)
                .resizable()
                .scaledToFit()
                .aspectRatio(contentMode: .fit)
                .frame(width: 34, height: 34)
        }
        .onAppear(perform: mainMessagesVM.retrieveProfileImageFromDisk)
    }
    
    private var newMessageView: some View {
        Button {
            
        } label: {
            HStack {
                Spacer()
                Text("+ New Message")
                // font here
                Spacer()
            }
            .foregroundColor(.white)
            .padding(.vertical)
            .background(.blue)
            .cornerRadius(Constants.roundedCornerRadius)
            .padding(.horizontal)
            .shadow(radius: Constants.buttonShadowRadius)
        }
    }
    
}

struct MainMessagesView_Previews: PreviewProvider {
    static var previews: some View {
        MainMessagesView()
    }
}
