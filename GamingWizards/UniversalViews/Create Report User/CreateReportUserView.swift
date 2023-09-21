//
//  CreateReportUserView.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 9/19/23.
//

import SwiftUI

struct CreateReportUserView: View {
    @ObservedObject private var createReportUserVM: CreateReportUserViewModel
    @State var reportReason: ReportReason
    @Binding var reporterId: String
    @Binding var reportedUser: User
    @State var userReportedMessage: String
    @Binding var chatRoomId: String
    
    @State private var isSheetPresented = false
    
    init(
        createReportUserVM: CreateReportUserViewModel = CreateReportUserViewModel(),
        reportReason: ReportReason = .other,
        reporterId: Binding<String>,
        reportedUser: Binding<User>,
        userReportedMessage: String = "",
        chatRoomId: Binding<String>
    ) {
        self._createReportUserVM = ObservedObject(wrappedValue: createReportUserVM)
        self.reportReason = reportReason
        self._reporterId = reporterId
        self._reportedUser = reportedUser
        self.userReportedMessage = userReportedMessage
        self._chatRoomId = chatRoomId
    }
    
    var body: some View {
        ZStack {
            VStack {
                reportPopUp
                    .background(Color.clear)
            }

        }
    }
    
    private var reportPopUp: some View {
        
        Button(action: {
            isSheetPresented.toggle()
        }) {
            Image(systemName: "exclamationmark.bubble")
                .frame(width: 25, height: 25, alignment: .center)
                .foregroundColor(.blue)
        }
        .sheet(isPresented: $isSheetPresented, content: {
            VStack(spacing: 20) {
                Button(action: {
                    print("tim")
                    isSheetPresented.toggle()
                }) {
                    Text("Block")
                        .foregroundColor(.red)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(Constants.semiRoundedCornerRadius)
                }
                Button(action: {
                    Task {
                        let userReportInfo = createReportUserVM.constructUserReportBaseData(
                            reportReason: reportReason,
                            reporterId: reporterId,
                            reportedUserId: reportedUser.id,
                            userReportedMessage: userReportedMessage,
                            chatRoomId: chatRoomId
                        )
                        do {
                            try await createReportUserVM.handleSendUserReportWasTapped(userReport: userReportInfo)
                            isSheetPresented.toggle()
                        } catch {
                            print("Error: \(error)")
                        }
                    }
                }) {
                    Text("Report")
                        .foregroundColor(.red)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(Constants.semiRoundedCornerRadius)
                }
                Spacer()
                Button(action: {
                    isSheetPresented.toggle()
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
        })
    }
    
}

#Preview {
    CreateReportUserView(
        reportReason: .other,
        reporterId: .constant("YourReporterID"),
        reportedUser: .constant(User(id: "ReportedUserID")),
        chatRoomId: .constant("ChatRoomID")
    )
}
