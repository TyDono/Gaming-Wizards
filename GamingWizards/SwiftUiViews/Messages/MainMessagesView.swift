//
//  MainMessagesView.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 3/30/23.
//

import SwiftUI

struct MainMessagesView: View {
    @ObservedObject private var mainMessagesVM: MainMessagesViewModel
    
    init() {
        self.mainMessagesVM = .init()
    }
    
    var body: some View {
        ZStack {
            NavigationStack {
                VStack {
                    mainMessagesCustomNavBar
                    messagesScrollView
                }
                .navigationBarHidden(true)
            }
        }
        .task {
//            mainMessagesVM.fbFirestoreHelper.retrieveFriendsListener(user: mainMessagesVM.user)
        }
        .onDisappear {
//            mainMessagesVM.fbFirestoreHelper.stopListening()
        }
        .navigationDestination(isPresented: $mainMessagesVM.isDetailedMessageViewShowing) {
            ChatLogView(chatUser: mainMessagesVM.selectedContact)
        }
    }
    
    private var messagesScrollView: some View {
        ScrollView {
            //change to mainMessagesVM.savedFriendEntities later when i have a fix
            ForEach(mainMessagesVM.coredataController.savedFriendEntities, id: \.self) { contact in
                Button {
                    mainMessagesVM.selectedContact = contact
                    mainMessagesVM.isDetailedMessageViewShowing.toggle()
                } label: {
                    VStack {
                        HStack(spacing: 16) {
                            MessengerProfileView(profileImageString: Binding<String>(
                                get: { contact.imageString ?? "1993" },
                                set: { contact.imageString = $0 }
                            ))
                            VStack(alignment: .leading) {
                                Text(contact.displayName ?? "")
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
                    .foregroundColor(.black)
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                }
            }
            .padding(.bottom, 50)
        }
        .onAppear {
            print(mainMessagesVM.savedFriendEntities)
            print(mainMessagesVM.coredataController.savedFriendEntities)
        }
    }
    
//    private var messengerProfileImage: some View {
//
//        Image(systemName: "person.fill")
//            .font(.system(size: 32))
//            .padding(8)
//            .overlay(RoundedRectangle(cornerRadius: 44)
//                .stroke( .black,
//                       lineWidth: 1)
//            )
//            .scaledToFit()
//            .frame(width: 32, height: 32)
//
//    }
    
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
            Image(uiImage: (mainMessagesVM.mainUserProfileImage ?? UIImage(named: "WantedWizard+"))!)
                .resizable()
                .scaledToFit()
                .aspectRatio(contentMode: .fit)
                .frame(width: 34, height: 34)
        }
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
