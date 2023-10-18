//
//  TabView.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 10/4/22.
//

import SwiftUI

struct MainTabView: View {
    @State var selectedTab = Constants.accountTabViewString
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
            .tag(Constants.accountTabViewString)
            
            NavigationStack {
                UserSearchView(debouncer: Debouncer(delay: 0.5), tabSelection: $selectedTab)
            }
            .tabItem {
                Label("Search", systemImage: "magnifyingglass")
            }
            .tag(Constants.searchTabViewString)
            
            NavigationStack {
                MainMessagesView()
            }
            .tabItem {
                Label("Messages", systemImage: "message")
            }
            .tag(Constants.messageTabViewString)
            
//            NavigationStack {
//                MapBoxView()
//            }
            
            // Map will return post MVP. I don't need map to use location services.
            /*
            .tabItem {
                Label("Map", systemImage: "map")
            }
            .tag(Constants.mapTabViewString)
             */
            
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
