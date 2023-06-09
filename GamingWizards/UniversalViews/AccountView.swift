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
    @Binding var profileImageString: String
    @Binding var profileImage: UIImage?
    @Binding var friendCodeId: String
    @Binding var listOfGames: [String]?
    @Binding var groupSize: String?
    @Binding var age: String?
    @Binding var about: String?
    @Binding var title: String?
    @Binding var availability: String?
    @Binding var isPayToPlay: Bool
    @Binding var isUserSolo: Bool
    
    var body: some View {
        ZStack {
            VStack {
                ScrollView {
                    Group {
                        Spacer()
                        profileTitleView
                        profileImageView
                        profileDisplayName
                        Divider()
                            .background(Color.black)
                        profileUserLocationView
                        Divider()
                            .background(Color.black)
                    }
                    Group {
                        profileIsSolo
                        Divider()
                            .background(Color.black)
                        profileAgeView
                        Divider()
                            .background(Color.black)
                        profileAvailability
                        Divider()
                            .background(Color.black)
                    }
                    Group {
                        profileIsPayToPlayView
                        Divider()
                            .background(Color.black)
                        profileAboutView
                            .lineLimit(nil)
                        Divider()
                            .background(Color.black)
                        //                profileNameView
                        profileFriendCodeIdView
                        Divider()
                            .background(Color.black)
                        profileListOfGamesView
                    }
                }
            }
            .padding(.horizontal, 20)
            .background(Color.clear)
            .font(.globalFont(.luminari, size: 16))
        }
    }
    
    private var profileTitleView: some View {
        VStack {
            if let profileTitle = title {
                Text(profileTitle)
                    .frame(
                        maxWidth: .infinity,
                        maxHeight: .infinity,
                        alignment: .center)
                    .lineLimit(nil)
                    .font(.globalFont(.luminari, size: 28))
                    .bold()
            }
        }
    }
    private var profileDisplayName: some View {
        VStack {
            if let profileDisplayName = displayName {
                Text(profileDisplayName)
                    .frame(
                        maxWidth: .infinity,
                        maxHeight: .infinity,
                        alignment: .center)
                    .lineLimit(nil)
            }
        }
    }
    
    private var profileImageView: some View {
        VStack {
            if let profileImage = profileImage {
                Image(uiImage: profileImage)
                    .resizable()
                    .scaledToFit()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: Constants.profileImageWidth, height: Constants.profileImageHeight, alignment: .center)
            } else {
//                UIImage(named: "WantedWizard")!
                Image("WantedWizard")
                    .resizable()
                    .scaledToFit()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: Constants.profileImageWidth, height: Constants.profileImageHeight, alignment: .center)
            }
        }
    }
    
    private var profileIsSolo: some View {
        VStack {
            Text("Group Size")
                .frame(
                    maxWidth: .infinity,
                    maxHeight: .infinity,
                    alignment: .center)
                .foregroundColor(.gray)
                .font(.globalFont(.luminari, size: 16))
            Text(isUserSolo == true ? "Solo" : "Group")
                .frame(
                    maxWidth: .infinity,
                    maxHeight: .infinity,
                    alignment: .leading)
        }
    }
    
    private var profileAgeView: some View {
        VStack {
            if let profileAge = age {
                    Text("Age")
                        .frame(
                            maxWidth: .infinity,
                            maxHeight: .infinity,
                            alignment: .center)
                        .foregroundColor(.gray)
                        .font(.globalFont(.luminari, size: 16))
                    Text("\(profileAge)")
                        .frame(
                            maxWidth: .infinity,
                            maxHeight: .infinity,
                            alignment: .leading)
            }
        }
    }
    
    private var profileAboutView: some View {
        VStack {
            if let profileAbout = about {
                VStack {
                    Text("About")
                        .frame(
                            maxWidth: .infinity,
                            maxHeight: .infinity,
                            alignment: .center)
                        .foregroundColor(.gray)
                        .font(.globalFont(.luminari, size: 14))
                    Text(profileAbout)
                        .frame(
                            maxWidth: .infinity,
                            maxHeight: .infinity,
                            alignment: .leading)
                        .lineLimit(nil)
                }
            }
        }
    }
    
    private var profileListOfGamesView: some View {
        VStack {
            Text("Games")
                .frame(
                    maxWidth: .infinity,
                    maxHeight: .infinity,
                    alignment: .center)
                .foregroundColor(.gray)
                .font(.globalFont(.luminari, size: 12))
            List {
                ForEach(listOfGames ?? [], id: \.self) { game in
                    Text("a game should be here")
                    Text(game)
                        .frame(
                            maxWidth: .infinity,
                            maxHeight: .infinity,
                            alignment: .leading)
                }
            }
        }
//                        .lineLimit(nil)
//                        .font(.globalFont(.luminari, size: 14))
//                        .padding(.vertical, 8)
//                        .listRowBackground(
//                            RoundedRectangle(cornerRadius: 5)
//                                .background(.red)
//                                .foregroundColor(.black)
//                                .opacity(1.0)
//                                .padding(
//                                    EdgeInsets(
//                                        top: 2,
//                                        leading: 6,
//                                        bottom: 2,
//                                        trailing: 6
//                                    )
//                                )
//                        )
//                }
//                .listRowBackground(
//                    RoundedRectangle(cornerRadius: 5)
//                        .background(.clear)
//                        .foregroundColor(.clear)
//                        .padding(
//                            EdgeInsets(
//                                top: 2,
//                                leading: 6,
//                                bottom: 2,
//                                trailing: 6
//                            )
//                        )
//                )
//            }
//        }
//        .listStyle(.plain)
//        .background(Color.clear)
    }
    
    private var profileAvailability: some View {
        VStack {
            Text("Availability")
                .frame(
                    maxWidth: .infinity,
                    maxHeight: .infinity,
                    alignment: .center)
                .foregroundColor(.gray)
                .font(.globalFont(.luminari, size: 12))
            if let userAvailability = availability {
                Text(userAvailability)
                    .frame(
                        maxWidth: .infinity,
                        maxHeight: .infinity,
                        alignment: .leading)
                    .lineLimit(nil)
            }
        }
    }
    
    private var profileIsPayToPlayView: some View {
        VStack {
            Text(isPayToPlay == true ? "Pay To Play" : "Free To Play")
                .frame(
                    maxWidth: .infinity,
                    maxHeight: .infinity,
                    alignment: .leading)
            // Add rates below if is pay to play at later date
        }
    }
    
    private var profileFriendCodeIdView: some View {
        VStack {
//            if let profileFriendCodeId = friendCodeId {
                VStack {
                    Text("Friend Code")
                        .frame(
                            maxWidth: .infinity,
                            maxHeight: .infinity,
                            alignment: .center)
                        .foregroundColor(.gray)
                        .font(.globalFont(.luminari, size: 14))
                    Text(friendCodeId)
                        .frame(
                            maxWidth: .infinity,
                            maxHeight: .infinity,
                            alignment: .leading)
                }
//            }
        }
    }
    
    private var profileUserLocationView: some View {
        VStack {
            if let profileUserLocation = userLocation {
                VStack {
                    Text("\(displayName ?? "")'s Location")
                        .frame(
                            maxWidth: .infinity,
                            maxHeight: .infinity,
                            alignment: .center)
                        .foregroundColor(.gray)
                        .font(.globalFont(.luminari, size: 14))
                    Text(profileUserLocation)
                        .frame(
                            maxWidth: .infinity,
                            maxHeight: .infinity,
                            alignment: .leading)
                        .lineLimit(nil)
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

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView(displayName: .constant("John Doe"),
                    userLocation: .constant("New York"),
                    profileImageString: .constant("profileImageString"),
                    profileImage: .constant(UIImage(named: "WantedWizard")),
                    friendCodeId: .constant("ABC123"),
                    listOfGames: .constant(["Game 1", "Game 2", "Game 3"]),
                    groupSize: .constant("Group"),
                    age: .constant("30"),
                    about: .constant("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed pellentesque tristique lacus id vestibulum. Nulla at justo augue. Mauris a ullamcorper tellus, ut semper ex. Morbi eget sapien ut metus maximus elementum. Fusce a tincidunt justo. Etiam rutrum tellus at libero fringilla, et fringilla nunc dapibus. Phasellus ut orci ac purus lacinia ultricies ac et odio. Nullam consectetur, lectus vitae cursus lacinia, nisl nulla tempus tortor, vel aliquet ligula diam sed erat. Nulla facilisi. Sed sem sapien, lobortis non turpis sit amet, euismod rhoncus purus."),
                    title: .constant("Title"),
                    availability: .constant("Available from  ringilla, et fringilla nunc dapibus. Phasellus ut orci ac purus lacinia ultricies ac et odio. Nullam consectetur, lectus vitae cursus lacinia, nisl nulla tempus tortor, vel aliquet ligula diam sed erat. Nulla facilisi. Sed sem sapien, lo"),
                    isPayToPlay: .constant(true),
                    isUserSolo: .constant(false))
    }
}

