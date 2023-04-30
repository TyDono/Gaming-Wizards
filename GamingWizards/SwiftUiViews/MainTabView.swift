//
//  TabView.swift
//  Foodiii
//
//  Created by Tyler Donohue on 10/4/22.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = "Account"
    init() {
        UITabBar.appearance().backgroundColor = UIColor.white
        
//        UITabBar.appearance().shadowImage = UIImage()
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            
            NavigationStack {
                HomeView()
            }
            .padding(.top)
            .tabItem {
                Label("Account", systemImage: "gear")
            }
            .badge(Constants.friendRequestCount)
            .tag("Account")
            
            NavigationStack {
                InvitationView()
            }
            .tabItem {
                Label("Order", systemImage: "menucard")
            }
            .tag("Order")
            
            NavigationStack {
                FoodThemeSelectionView()
            }
            .tabItem {
                Label("Host", systemImage: "fork.knife")
            }
            .tag("Host")
            
            NavigationStack {
                MapBoxView()
            }
            .tabItem {
                Label("Map", systemImage: "map")
            }
            .tag("Map")
            
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
