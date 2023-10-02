//
//  SearchSettingsView.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 9/28/23.
//

import SwiftUI
//            .navigationBarTitleDisplayMode(.inline)
//            .navigationBarTitle("", displayMode: .inline)
//            .navigationBarItems(trailing: CustomNavigationTitle(titleImageSystemName: $searchSettingTitleSystemImageName, titleText: $searchSettingViewTitle))
struct SearchSettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var searchSettingsVM: SearchSettingsViewModel
    @State private var isDistancePickerSettingsShowing: Bool = false
    @State private var searchSettingViewTitle: String? = "Search Settings"
    @State private var searchSettingTitleSystemImageName: String? = "slider.horizontal.3"
    
    init(searchSettingsVM: SearchSettingsViewModel) {
        self._searchSettingsVM = StateObject(wrappedValue: searchSettingsVM)
    }
    
    var body: some View {
        ZStack {
            NavigationStack {
                VStack {
                    List {
                        distanceSettingsButton
                    }
                }
            }
        }
        .sheet(isPresented: $isDistancePickerSettingsShowing, content: {
            VStack(spacing: 20) {
                DistancePickerView(distancePickerVM: searchSettingsVM.distancePickerViewModel)
            }
            .background(Color.clear)
            .presentationDetents([.height(200)])
            .padding()
        }).background(Color.clear)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    CustomNavigationTitle(titleImageSystemName: $searchSettingTitleSystemImageName, titleText: $searchSettingViewTitle)
                }
            }
    }
    
    private var distanceSettingsButton: some View {
        ZStack {
            Button {
                isDistancePickerSettingsShowing.toggle()
            } label: {
                Text("Distance Settings")
            }
        }
    }
    
}

//#Preview {
//    SearchSettingsView()
//}
