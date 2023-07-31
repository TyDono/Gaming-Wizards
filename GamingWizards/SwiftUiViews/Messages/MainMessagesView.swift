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
                ScrollView {
                    ForEach(0..<10, id: \.self) { num in
                        HStack(spacing: 16){
                            messengerProfileImage
                            VStack(alignment: .leading) {
                                Text("UserName")
                                    .font(.roboto(.bold, size: 14))
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
                    }.padding(.horizontal)
                    
                }
                newMessageView
            }.navigationBarHidden(true)
        }
    }
    
    private var newMessageView: some View {
        Button(action: {
            
        }) {
            VStack {
                Text("+ New Message")
                //font
                Spacer()
            }
            .cornerRadius(Constants.semiRoundedCornerRadius)
            .padding(.horizontal)
            
        }
    }
    
    
    
    private var messengerProfileImage: some View {
        Image(systemName: "person.fill")
            .padding()
            .overlay(RoundedRectangle(cornerRadius: 44)
                .stroke( .black,
                       lineWidth: 1)
            )
//            .resizable()
            .scaledToFit()
//            .aspectRatio(contentMode: .fit)
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
            Image(systemName: "gear")
        }
        .padding()
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
    
}

struct HotPotView_Previews: PreviewProvider {
    static var previews: some View {
        MainMessagesView()
    }
}
