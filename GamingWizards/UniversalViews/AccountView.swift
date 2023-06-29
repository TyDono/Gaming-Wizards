//
//  AccountView.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 6/9/23.
//

import SwiftUI
import Foundation

struct AccountView: View {
//    @Binding var isShowingAccountView: Bool?
//    @Binding var isShowingEditAccountView: Bool?
    
//    @Binding var firstName: String?
//    @Binding var lastName: String?
    @Binding var displayName: String?
//    @Binding var email: String?
    @Binding var userLocation: String?
    @Binding var profileImageString: String?
    @Binding var profileImage: UIImage?
    @Binding var friendCodeId: String?
    @Binding var listOfGames: [String?]
    @Binding var groupSize: String?
    @Binding var age: String?
    @Binding var about: String?
    @Binding var title: String?
    @Binding var isPayToPlay: Bool?
    @Binding var isUserSolo: Bool?
    
    var body: some View {
        ZStack {
            VStack(alignment: .center) {
                Group {
                    profileTitleView
                    profileImageView
                    profileDisplayName
                    Divider()
                        .background(Color.black)
                    profileUserLocationView
                    Divider()
                        .background(Color.black)
                    profileIsSolo
                    Divider()
                        .background(Color.black)
                }
                Group {
                    profileAgeView
                    Divider()
                        .background(Color.black)
                    profileIsPayToPlayView
                    Divider()
                        .background(Color.black)
                    profileAboutView
                    Divider()
                        .background(Color.black)
                    //                profileNameView
                    profileFriendCodeIdView
                }
            }
            .font(.globalFont(.luminari, size: 16))
            .navigationTitle(title ?? "")
        }
    }
    
    private var profileTitleView: (some View)?? {
        VStack {
            if let profileTitle = title {
                Text(profileTitle)
                    .font(.globalFont(.luminari, size: 28))
                    .bold()
            }
        }
    }
    private var profileDisplayName: some View {
        VStack {
            if let profileDisplayName = displayName {
                Text(profileDisplayName)
            }
        }
    }
    
    private var profileImageView: some View {
        VStack {
//            Spacer()
            if let profileImage = profileImage {
                Image(uiImage: profileImage)
                    .resizable()
                    .scaledToFit()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 250, height: 250)
            }
        }
    }
    
    private var profileIsSolo: some View {
        VStack {
            Text(isUserSolo == true ? "Solo" : "Group")
        }
    }
    
    private var profileAgeView: some View {
        VStack {
            if let profileAge = age {
                VStack {
                    Text("Age")
                        .foregroundColor(.gray)
                        .font(.globalFont(.luminari, size: 16))
                    Text("\(profileAge)")
                }
            }
        }
    }
    
    private var profileAboutView: some View {
        VStack {
            if let profileAbout = about {
                VStack {
                    Text("About")
                        .foregroundColor(.gray)
                        .font(.globalFont(.luminari, size: 14))
                    Text(profileAbout)
                }
            }
        }
    }
    
    private var profileListOfGamesView: some View {
        List {
            ForEach(listOfGames, id: \.self) { game in
                VStack {
                    Text("Games")
                        .foregroundColor(.gray)
                        .font(.globalFont(.luminari, size: 12))
                    Text(game ?? "")
                        .font(.globalFont(.luminari, size: 14))
                        .padding(.vertical, 8)
                }
                
            }
            .listRowBackground(
                RoundedRectangle(cornerRadius: 5)
                    .background(.clear)
                    .foregroundColor(.white)
                    .padding(
                        EdgeInsets(
                            top: 2,
                            leading: 6,
                            bottom: 2,
                            trailing: 6
                        )
                    )
            )
        }
        .listStyle(.plain)
        .background(Color.clear)
    }
    
    private var profileIsPayToPlayView: some View {
        VStack {
            Text(isPayToPlay == true ? "Pay To Play" : "Free To Play")
            // Add rates below if is pay to play at later date
        }
    }
    
    private var profileFriendCodeIdView: some View {
        VStack {
            if let profileFriendCodeId = friendCodeId {
                VStack {
                    Text("Friend Code")
                        .foregroundColor(.gray)
                        .font(.globalFont(.luminari, size: 14))
                    Text(profileFriendCodeId)
                }
            }
        }
    }
    
    private var profileUserLocationView: some View {
        VStack {
            if let profileUserLocation = userLocation {
                VStack {
                    Text("\(displayName ?? "")'s Location")
                        .foregroundColor(.gray)
                        .font(.globalFont(.luminari, size: 14))
                    Text(profileUserLocation)
                }
            }
        }
    }
    
//    private var profileNameView: some View {
//        VStack {
//            if let profileFirstName = firstName, let profileLastName = lastName {
//                Text("\(profileFirstName) \(profileLastName)")
//            }
//        }
//    }
    
}

//struct AccountView_Previews: PreviewProvider {
//    static var previews: some View {
//        AccountView()
//    }
//}
