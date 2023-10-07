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
    @State private var isAgeRangeSettingsShowing: Bool = false
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
                        ageRangeSettingsButton
                    }
                }
            }
        }
        .background(Color.clear)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    CustomNavigationTitle(titleImageSystemName: $searchSettingTitleSystemImageName, titleText: $searchSettingViewTitle)
                }
            }
    }
    
    private var ageRangeSettingsButton: some View {
        VStack {
            Button {
                isAgeRangeSettingsShowing.toggle()
            } label: {
                Text("Age Range Settings")
                    .font(.system(size: 20))
            }
            .sheet(isPresented: $isAgeRangeSettingsShowing, content: {
                VStack(spacing: 20) {
                    TwoPointRangeSliderView()
                }
                .background(Color.clear)
                .presentationDetents([.height(200)])
                .padding()
            })
        }
    }
    
    private var distanceSettingsButton: some View {
        VStack {
            Button {
                isDistancePickerSettingsShowing.toggle()
            } label: {
                Text("Distance Settings")
                    .font(.system(size: 20))
            }
            .sheet(isPresented: $isDistancePickerSettingsShowing, content: {
                VStack(spacing: 20) {
                    DistancePickerView(distancePickerVM: searchSettingsVM.distancePickerViewModel)
                }
                .background(Color.clear)
                .presentationDetents([.height(200)])
                .padding()
            })
        }
    }
    
}

//#Preview {
//    SearchSettingsView()
//}
