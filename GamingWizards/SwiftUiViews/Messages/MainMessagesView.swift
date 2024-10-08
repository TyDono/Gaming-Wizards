//
//  MainMessagesView.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 3/30/23.
//

import SwiftUI

struct MainMessagesView: View {
    @Environment(\.presentationMode) private var presentationMode
    @StateObject private var mainMessagesVM: MainMessagesViewModel
    @State private var isChatLogViewPresented: Bool = false
    
    init(
        mainMessagesVM: MainMessagesViewModel = MainMessagesViewModel(listOfFriends: [])
    ) {
        _mainMessagesVM = StateObject(wrappedValue: mainMessagesVM)
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
        .onAppear {
            Task {
                await mainMessagesVM.callListenForChangesInUserFriendListSubCollection()
//                await mainMessagesVM.callForCoreDataEntities()
//                await mainMessagesVM.callFetchListOfFriends()
            }
        }
        .onDisappear {
            mainMessagesVM.stopListening()
            mainMessagesVM.cancelFriend()
        }
        .navigationDestination(isPresented: $isChatLogViewPresented) {
            ChatLogView(presentationMode: self.presentationMode,
                        chatUser: mainMessagesVM.selectedContact,
                        isChatLogViewPresented: $isChatLogViewPresented)
        }
    }
    
    private var messagesScrollView: some View {
        ScrollView {
            ForEach(Array(mainMessagesVM.listOfFriends.enumerated()), id: \.element) { (index, friend) in
                let timeAgo = mainMessagesVM.timeUtilsService.timeAgoString(from: friend.recentMessageTimeStamp ?? Date())
                
                Button {
                    mainMessagesVM.selectedContact = friend
                    isChatLogViewPresented.toggle()
                } label: {
                    VStack {
                        HStack(spacing: 16) {
                            MessengerProfileView(profileImageString: Binding<String>(
                                get: { mainMessagesVM.listOfFriends[index].imageString },
                                set: { mainMessagesVM.listOfFriends[index].imageString = $0 }
                            ))
                            VStack(alignment: .leading) {
                                Text(friend.displayName)
                                    .font(.roboto(.bold, size: 16))
                                    .lineLimit(2)
                                Text(friend.recentMessageText)
                                    .font(.roboto(.semibold, size: 14))
                                    .foregroundColor(.lightGrey)
                                    .lineLimit(2)
                            }
                            Spacer()
                            Text("Sent \(timeAgo)")
                                .font(.roboto(.semibold, size: 15))
                        }
                        Divider()
                            .padding(.vertical, 8)
                    }
                }
                .foregroundColor(.black)
                .padding(.horizontal)
                .padding(.vertical, 8)
            }
            .padding(.bottom, 50)
        }
    }
    
    private var mainMessagesCustomNavBar: some View {
        HStack (spacing: 16){
            profileImageView
//                        .font(.system(size: 34, weight: .heavy))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(mainMessagesVM.user.displayName ?? "")
                    .font(.roboto(.bold, size: 24))
                HStack {
                    OnlineStatus(circleColor: mainMessagesVM.onlineStatus ? .green : .red,
                                 circleWidth: 14,
                                 circleHeight: 14)
                    
//                    .task {
//                        await mainMessagesVM.onlineStatusCircleWasTapped(toId: "POST MVP")
//                    }
//                    Circle()
//                        .foregroundColor(.green)
//                        .frame(width: 14, height: 14)
                    Text(mainMessagesVM.onlineStatus ? "Online" : "Offline")
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
            withAnimation(Animation.easeInOut(duration: 0.9).speed(1)) {
                mainMessagesVM.onlineStatus.toggle()
            }
            // takes you to friend's list maybe? idk. stand by.
        } label: {
            Image(systemName: "gear")
        }

    }
    
    private var profileImageView: some View {
        VStack {
            Image(uiImage: (mainMessagesVM.mainUserProfileImage ?? UIImage(named: "WantedWizard+"))!)
                .resizable()
                .scaledToFill()
                .frame(width: 34, height: 34)
                .clipped()
                .cornerRadius(34)
                .overlay(RoundedRectangle(cornerRadius: 44)
                    .stroke(.black, lineWidth: 1)
                )
                .shadow(radius: 5)
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

//struct MainMessagesView_Previews: PreviewProvider {
//    static var previews: some View {
//        MainMessagesView()
//    }
//}
