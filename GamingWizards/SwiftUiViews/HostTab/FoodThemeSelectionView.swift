//
//  RestaurantSelectionView.swift
//  Foodiii
//
//  Created by Tyler Donohue on 3/29/23.
//

import SwiftUI

struct FoodThemeSelectionView: View {
    @StateObject private var foodThemeSelectionVM =  FoodThemeSelectionViewModel()
    
    var body: some View {
        ZStack {
            VStack {
//                titleTipView
                List { //have themes such as hot pot, bbq, picnic for starters. add picking up/delivering food later
                    hotPotButtonView
                }
            }
            .toolbar {
            }
            .navigationBarTitle("Food Theme", displayMode: .large)
        }
    }
    
    private var titleTipView: some View {
        VStack {
            Text("Select a theme")
                .font(.system(size: 15))
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
            Spacer()
            
        }
        .padding()
    }
    
    private var driveThroughButtonView: some View {
        Button(action: {
//            isFriendListShowing = true
        }) {
            HStack {
                if Constants.friendRequestCount != 0 {
                    Text("\(Constants.friendRequestCount)")
                        .foregroundColor(.white)
                        .background(
                            Circle()
                                .fill(.red)
                                .frame(width: 20, height: 20)
                        )
                }
                Image(systemName: "person.2")
                Text("Friends")
                    .frame(maxWidth: .infinity,
                           alignment: .leading)
                    .font(.roboto(.semibold,
                                  size: 20))
                
                Image(systemName: "chevron.right")
                    .frame(maxWidth: .infinity,
                           alignment: .trailing)
            }
        }
        .listRowInsets(EdgeInsets())
        .padding()
    }
    
    private var hotPotButtonView: some View {
        NavigationStack {
            //        Button(action: {
            NavigationLink {
                HotPotView()
                //                    .environmentObject(friendListVM)
                //                    .onAppear {
                //                        friendListVM.friendWasTapped(friend: friend)
                //                    }
            } label: {
                HStack {
                    Image("icons8-kitchen")
                        .scaledToFit()
                    Text("Hot Pot")
                        .frame(maxWidth: .infinity,
                               alignment: .leading)
                        .font(.roboto(.semibold,
                                      size: 20))
                }
            }
            
            //        })
        }
    }
    
}

struct RestaurantSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        FoodThemeSelectionView()
    }
}
