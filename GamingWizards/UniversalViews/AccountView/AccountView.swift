//
//  AccountView.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 6/9/23.
//

import SwiftUI
import Foundation

struct AccountView: View {
    @Environment(\.defaultMinListRowHeight) var minRowHeight
    @ObservedObject private var accountVM: AccountViewModel
//    @Binding var isShowingAccountView: Bool?
//    @Binding var isShowingEditAccountView: Bool?
    
//    @Binding var firstName: String?
//    @Binding var lastName: String?
    @Binding var displayName: String?
//    @Binding var email: String?
    @Binding var userLocation: String?
    @Binding var profileImageString: String
    @Binding var profileImage: UIImage?
//    @Binding var friendCodeId: String
    @Binding var listOfGames: [String]?
    @Binding var groupSize: String?
    @Binding var age: String?
    @Binding var about: String?
    @Binding var title: String?
    @Binding var availability: String?
    @Binding var isPayToPlay: Bool
    @Binding var isUserSolo: Bool
    
    init(
        displayName: Binding<String?>,
        userLocation: Binding<String?>,
        profileImageString: Binding<String>,
        profileImage: Binding<UIImage?>,
//        friendCodeId: Binding<String>,
        listOfGames: Binding<[String]?>,
        groupSize: Binding<String?>,
        age: Binding<String?>,
        about: Binding<String?>,
        title: Binding<String?>,
        availability: Binding<String?>,
        isPayToPlay: Binding<Bool>,
        isUserSolo: Binding<Bool>
    ) {
        _displayName = displayName
        _userLocation = userLocation
        _profileImageString = profileImageString
        _profileImage = profileImage
//        _friendCodeId = friendCodeId
        _listOfGames = listOfGames
        _groupSize = groupSize
        _age = age
        _about = about
        _title = title
        _availability = availability
        _isPayToPlay = isPayToPlay
        _isUserSolo = isUserSolo
        self.accountVM = .init()
    }
    
    var body: some View {
        ZStack {
            VStack {
                ScrollView {
                    Group {
                        profileTitleView
                        profileImageView
                            .padding()
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
//                        profileFriendCodeIdView
//                        Divider()
                            .background(Color.black)
                        listOfGamesTagView
//                        profileListOfGamesView
                    }
                }
            }
            .padding(.horizontal, 20)
            .background(Color.clear)
//            .font(.globalFont(.luminari, size: 16))
            .font(.roboto(.regular, size: 16))
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
//                    .font(.roboto(.regular, size: 28))
                    .bold()
            }
        }
    }
    private var profileDisplayName: some View {
        VStack {
            if let profileDisplayName = displayName {
                HStack {
                    Image(systemName: "pencil")
                        .foregroundColor(.black)
                    Text(profileDisplayName)
                        .frame(
                            maxWidth: .infinity,
                            maxHeight: .infinity,
                            alignment: .leading)
                        .lineLimit(nil)
                        .font(.roboto(.regular, size: 24))
                    Spacer()
                }
            }
        }
    }
    
    private var profileImageView: some View {
        VStack {
            Image(uiImage: (profileImage ?? UIImage(named: Constants.wantedWizardImageString))!)
                .resizable()
                .scaledToFit()
                .aspectRatio(contentMode: .fit)
                .frame(width: Constants.profileImageWidth, height: Constants.profileImageHeight, alignment: .center)
        }
    }
    
    private var profileIsSolo: some View {
        VStack {
            HStack {
                Image(systemName: isUserSolo ? "person" : "person.3")
                    .foregroundColor(.black)
                Text("Group Size")
                    .foregroundColor(.black)
                //                .font(.globalFont(.luminari, size: 16))
                    .font(.roboto(.regular, size: 16))
                Spacer()
            }
            Text(isUserSolo == true ? "Solo" : "Group")
                .frame(
                    maxWidth: .infinity,
                    maxHeight: .infinity,
                    alignment: .leading)
                .foregroundColor(.gray)
        }
    }
//    Image(systemName: isUserSolo ? "person" : "person.3")
    private var profileAgeView: some View {
        VStack {
            if let profileAge = age {
                HStack {
                    Image(systemName: "birthday.cake")
                        .foregroundColor(.black)
                    Text("Age")
                        .foregroundColor(.black)
                    //                        .font(.globalFont(.luminari, size: 16))
                        .font(.roboto(.regular, size: 16))
                    Spacer()
                }
                    Text("\(profileAge)")
                        .frame(
                            maxWidth: .infinity,
                            maxHeight: .infinity,
                            alignment: .leading)
                        .foregroundColor(.gray)
            }
        }
    }
    
    private var profileAboutView: some View {
        VStack {
            if let profileAbout = about {
                VStack {
                    HStack {
                        Image(systemName: "rectangle.and.pencil.and.ellipsis")
                            .foregroundColor(.black)
                        Text("About")
                            .foregroundColor(.black)
                        //                        .font(.globalFont(.luminari, size: 14))
                            .font(.roboto(.regular, size: 14))
                        Spacer()
                    }
                    Text(profileAbout)
                        .frame(
                            maxWidth: .infinity,
                            maxHeight: .infinity,
                            alignment: .leading)
                        .lineLimit(nil)
                        .foregroundColor(.gray)

                }
            }
        }
    }
    
    private var listOfGamesTagView: some View {
        /*
        ScrollView {
            FlowLayout(mode: .scrollable,
                       binding: $filterer.searchText,
                       items: filterer.gamesFilter) { gameItem in
                Text(gameItem.textName)
                    .font(.globalFont(.luminari, size: 12))
                    .foregroundColor(gameItem.isSelected ? Color.white : Color.black)
                    .background(
                        RoundedRectangle(cornerRadius: Constants.tagFlowLayoutCornerRadius)
                            .border(Color.clear)
                            .foregroundColor(gameItem.isSelected ? Color.blue : Color.lightGrey)
                            .padding(-8)
                    )
                    .padding()
                    .onTapGesture {
                        manageListOfGamesVM.gameTagWasTapped(tappedGameTag: gameItem)
                        filterer.searchText = filterer.searchText // Updates the UI. dons't know why. don't try. accept monkey wrench code here.
                    }
            }
        }
        .onAppear {
            manageListOfGamesVM.updateGameTagsWithMatchingGames(filterer: filterer.gamesFilter)
        }
        */
        
        VStack {
            HStack {
                Image(systemName: "gamecontroller")
                    .foregroundColor(.black)
                Text("Games")
                    .foregroundColor(.black)
                //                .font(.globalFont(.luminari, size: 12))
                    .font(.roboto(.regular, size: 12))
                Spacer()
            }
            ScrollView {
                FlowLayout(mode: .scrollable,
                           binding: .constant(5),
                           items: listOfGames ?? []) { gameItem in
                    Text(gameItem)
//                        .font(.globalFont(.luminari, size: 16))
                        .font(.roboto(.regular, size: 16))
                        .foregroundColor(accountVM.user.listOfGames?.contains(gameItem) == true ? .white : .black)
                        .background(
                            RoundedRectangle(cornerRadius: Constants.tagFlowLayoutCornerRadius)
                                .border(Color.clear)
                                .foregroundColor(accountVM.user.listOfGames?.contains(gameItem) == true ? .blue : .lightGrey)
                                .padding(-8)
                        )
                        .padding()
                        .onTapGesture {
                            if accountVM.user.listOfGames?.contains(gameItem) == true {
                                accountVM.callDeleteItemFromArray(tappedGame: gameItem)
                            } else {
                                accountVM.callAddItemToArray(tappedGame: gameItem)
                            }
                        }
                }
            }
        }
    }
    
    private var profileAvailability: some View {
        VStack {
            HStack{
                Image(systemName: "calendar")
                Text("Availability")
                    .foregroundColor(.black)
                //                .font(.globalFont(.luminari, size: 12))
                    .font(.roboto(.regular, size: 12))
                Spacer()
            }
            if let userAvailability = availability {
                Text(userAvailability)
                    .frame(
                        maxWidth: .infinity,
                        maxHeight: .infinity,
                        alignment: .leading)
                    .lineLimit(nil)
                    .foregroundColor(.gray)
            }
        }
    }
    
    private var profileIsPayToPlayView: some View {
        VStack {
            HStack {
                Image(systemName: isPayToPlay ? "dollarsign" : "")
                Text(isPayToPlay == true ? "Pay To Play" : "Free To Play")
                Spacer()
            }
            // Add rates below if is pay to play at later date
        }
    }
    
//    private var profileFriendCodeIdView: some View {
//        VStack {
//            VStack {
//                HStack {
//                    Image(systemName: "barcode")
//                        .foregroundColor(.black)
//                    Text("Friend Code")
//                        .foregroundColor(.black)
//                //                        .font(.globalFont(.luminari, size: 14))
//                        .font(.roboto(.regular, size: 14))
//                    Spacer()
//                }
//                Text(friendCodeId)
//                    .frame(
//                        maxWidth: .infinity,
//                        maxHeight: .infinity,
//                        alignment: .leading)
//                    .foregroundColor(.gray)
//                
//            }
//        }
//    }
    
    private var profileUserLocationView: some View {
        VStack {
            if let profileUserLocation = userLocation {
                VStack {
                    HStack {
                        Image(systemName: "location")
                        Text("\(displayName ?? "")'s Location")
                            .foregroundColor(.black)
                        //                        .font(.globalFont(.luminari, size: 14))
                            .font(.roboto(.regular, size: 14))
                        Spacer()
                    }
                    Text(profileUserLocation)
                        .lineLimit(nil)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.leading)
                        .frame(
                            maxWidth: .infinity,
                            maxHeight: .infinity,
                            alignment: .leading)

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
                    profileImage: .constant(UIImage(named: Constants.wantedWizardImageString)),
//                    friendCodeId: .constant("ABC123"),
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

