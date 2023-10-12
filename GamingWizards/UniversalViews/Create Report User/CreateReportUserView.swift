//
//  CreateReportUserView.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 9/19/23.
//

import SwiftUI

struct CreateReportUserView: View {
    @Binding var presentationMode: PresentationMode
    @ObservedObject private var createReportUserVM: CreateReportUserViewModel
//    @State var reportReason: ReportReason
    @Binding var reporterId: String
    @Binding var reportedUser: User
    @State var userReportedMessage: String = ""
    @Binding var chatRoomId: String
    @State private var selectedReasons: [ReportReason] = []
    @State private var isReportBlockPresented: Bool = false
    @State private var isReportReasonsPresented: Bool = false
    @State var userReportDescriptionTextEditorPlaceHolderText: String = "Your description here"
    @Binding var blockedUser: BlockedUser
    @Binding var friendEntity: FriendEntity
    
    
    init(
        presentationMode: Binding<PresentationMode>,
        createReportUserVM: CreateReportUserViewModel = CreateReportUserViewModel(),
//        reportReason: ReportReason,
        reporterId: Binding<String>,
        reportedUser: Binding<User>,
//        userReportedMessage: String,
        chatRoomId: Binding<String>,
        blockedUser: Binding<BlockedUser>,
        friendEntity: Binding<FriendEntity>
    ) {
        self._presentationMode = presentationMode
        self._createReportUserVM = ObservedObject(wrappedValue: createReportUserVM)
//        self.reportReason = reportReason
        self._reporterId = reporterId
        self._reportedUser = reportedUser
//        self.userReportedMessage = userReportedMessage
        self._chatRoomId = chatRoomId
        self._blockedUser = blockedUser
        self._friendEntity = friendEntity
    }
    
    var body: some View {
        ZStack {
            VStack {
                reportPopUp
                    .background(Color.clear)
            }
        }
    }
    
    private var customNavigationBar: some View {
        HStack {
            Button(action: {
                isReportReasonsPresented.toggle()
            }) {
                Image(systemName: "xmark")
                    .foregroundColor(.blue)
                    .padding()
                    .background(Color.clear)
                    .imageScale(.large)
            }
            
            Spacer()
            Image(systemName: "exclamationmark.shield")
            Text("ReportUser")
            Spacer()
            Button(action: {
                isReportReasonsPresented.toggle()
                Task {
                    let userReportInfo = createReportUserVM.constructUserReportBaseData(
                        reportReason: .other,
                        reporterId: reporterId,
                        reportedUserId: reportedUser.id,
                        userReportedMessage: createReportUserVM.userReportDescription,
                        chatRoomId: chatRoomId
                    )
                    await createReportUserVM.handleSendUserReportWasTapped(userReport: userReportInfo)
                    await createReportUserVM.handleBlockingUser(blockedUser: blockedUser, friendEntity: friendEntity)
                }
                $presentationMode.wrappedValue.dismiss()
            }) {
                Text("Submit")
                    .foregroundColor(.blue)
                    .padding()
                    .background(Color.clear)
            }
            
        }
        .background(Color.clear)
        .font(.headline)
        .foregroundColor(.primary)
        .navigationBarHidden(true)
    }
    
    private var userReportMessageDescription: some View {
        
            VStack {
                Text("Add a description to the report")
                    .font(.roboto(.semibold,
                                  size: 18))
                ZStack {
                    if createReportUserVM.userReportDescription.isEmpty {
                        TextEditor(text: $userReportDescriptionTextEditorPlaceHolderText)
                            .foregroundColor(.gray)
                            .disabled(true)
                            .frame(height: 135)
                    }
                    TextEditor(text: $createReportUserVM.userReportDescription.max(Constants.textViewMaxCharacters))
                        .opacity(createReportUserVM.userReportDescription.isEmpty ? 0.25 : 1)
                        .frame(height: 135)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 1)
                        )

//                TextEditor(text: $createReportUserVM.userReportDescription.max(Constants.textViewMaxCharacters))
//                    .foregroundColor(.black)
//                    .frame(height: 200)
//                //                .textFieldStyle(RoundedBorderTextFieldStyle())
//                    .foregroundStyle(.secondary)
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 10)
//                            .stroke(Color.black, lineWidth: 1)
//                    )
//                    .foregroundColor(createReportUserVM.userReportDescription.isEmpty ? Color.black.opacity(0.25) : .black)
//                    .padding(.horizontal)
//                    .padding(.vertical)
//                    .background(Color.white)
//                    .font(.roboto(.regular,
//                                  size: 16))
//                    if createReportUserVM.userReportDescription.isEmpty {
//                        Text("Your description here")
//                            .foregroundColor(Color(UIColor.placeholderText))
//                    }
            }
                .padding(.horizontal)
                .padding(.vertical)
        }
    }
    
    private var explanationText: some View {
        VStack {
            Text("Why are you reporting?")
                .frame(alignment: .leading)
                .lineLimit(nil)
                .font(.roboto(.semibold,
                              size: 18))
                .bold()
                .foregroundStyle(Color.black)
        }
        .background(Color.clear)
    }
    
    private var reportReasonsList: some View {
        List {
            ForEach(ReportReason.allCases, id: \.self) { reason in
                HStack {
                    Text(reason.rawValue)
                    Spacer()
                    Image(systemName: selectedReasons.contains(reason) ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(selectedReasons.contains(reason) ? .blue : .gray)
                        .onTapGesture {
                            withAnimation {
                                if selectedReasons.contains(reason) {
                                    selectedReasons.removeAll { $0 == reason }
                                } else {
                                    selectedReasons.append(reason)
                                }
                            }
                        }
                }
            }
        }
    }
    
    private var reportReasonsPopUpView: some View {
        NavigationView {
            VStack {
                customNavigationBar
                explanationText
                reportReasonsList
                userReportMessageDescription
                Spacer()
            }
            .navigationBarItems(leading:
                                    Button(action: {
                isReportReasonsPresented.toggle()
            }) {
                Text("Cancel")
                
            }
            )
        }
    }
    
    private var reportPopUp: some View {
        VStack {
            Button(action: {
                isReportBlockPresented.toggle()
                $presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "exclamationmark.bubble")
//                    .frame(width: 25, height: 25, alignment: .center)
                    .foregroundColor(.blue)
            }
            .sheet(isPresented: $isReportBlockPresented, content: {
                VStack(spacing: 20) {
                    Button(action: {
                        Task {
                            await createReportUserVM.handleBlockingUser(blockedUser: blockedUser, friendEntity: friendEntity)
                        }
                        isReportBlockPresented.toggle()
                    }) {
                        Text("Block")
                            .foregroundColor(.red)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(Constants.semiRoundedCornerRadius)
                    }
                    Button(action: {
                        isReportReasonsPresented.toggle()
                    }) {
                        Text("Report")
                            .foregroundColor(.red)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(Constants.semiRoundedCornerRadius)
                    }
                    .sheet(isPresented: $isReportReasonsPresented, content: {
                        reportReasonsPopUpView
                    })
                    Spacer()
                    Button(action: {
                        isReportBlockPresented.toggle()
                    }) {
                        Text("Cancel")
                            .foregroundColor(.blue)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(Constants.semiRoundedCornerRadius)
                    }
                }
                .background(Color.clear)
                .presentationDetents([.height(200)])
                .padding()
            }).background(Color.clear)
        }
    }
    
}

//#Preview {
//    CreateReportUserView(
////        reportReason: .other,
//        reporterId: .constant("YourReporterID"),
//        reportedUser: .constant(User(id: "ReportedUserID")),
//        userReportedMessage: "thy are beans", chatRoomId: .constant("ChatRoomID"),
//        blockedUser: .constant(BlockedUser(blockedUserId: "7778ht7",
//                                           displayName: "phil whil",
//                                           dateRemoved: Date()))
//    )
//}
