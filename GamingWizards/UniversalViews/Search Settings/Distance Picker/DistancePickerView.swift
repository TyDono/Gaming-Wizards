//
//  DistancePickerView.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 9/28/23.
//

import SwiftUI
import Combine

struct DistancePickerView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var distancePickerVM: DistancePickerViewModel
    
    init(distancePickerVM: DistancePickerViewModel) {
        _distancePickerVM = StateObject(wrappedValue: distancePickerVM)
    }
    
    var body: some View {
        ZStack {
            VStack {
                distancePickTitle
                    .padding()
                distancePickerMessage
                distancePickerSlider
                
            }
        }
        .task {
            await distancePickerVM.callCoreDataEntities()
        }
        .onDisappear {
            distancePickerVM.searchSettingsIsBeingCanceled()
        }
    }
    
    private var distancePickerSlider: some View {
        VStack {
            Slider(value: $distancePickerVM.miles, in: 1...500, step: 1.0)
                .padding()
                .onAppear {
                    guard let searchRadiusSettings = distancePickerVM.savedSearchSettings?.searchRadius else { return }
                    self.distancePickerVM.miles = searchRadiusSettings
                }
        }
        .onReceive(
            distancePickerVM.$miles
                .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
        ) { newMiles in
            
            guard let oldUserSearchSettings = distancePickerVM.savedSearchSettings else{  return }
            var newSearchSettings = oldUserSearchSettings
            newSearchSettings.searchRadius = newMiles
            
            Task {
                await distancePickerVM.callSaveChangesToFirestore(oldSearchSettingsData: oldUserSearchSettings, newSearchSettingsData: newSearchSettings)
            }
        }
    }

    
    /*
    private var distancePickerSlider: some View {
        VStack {
            Slider(value: Binding(
                get: {
                    self.distancePickerVM.miles
                },
                set: { newValue in
                    self.distancePickerVM.miles
//                    self.distancePickerVM.miles = self.distancePickerVM.mapExponential(value: newValue)
                }
            ), in: 1...500)
            .padding()
            .onChange(of: distancePickerVM.miles) { newMiles in
                distancePickerVM.saveDistanceSearchSettings(distance: newMiles)
            }
            .onAppear {
                self.distancePickerVM.miles = distancePickerVM.coreDataController.savedSearchSettingsEntity?.searchRadius ?? 0
            }
        }
    }
    */
    
    private var distancePickerMessage: some View {
        VStack {
            Text("How far are you looking for?")
                .font(.roboto(.bold, size: 18))
                .foregroundStyle(Color.lightGrey)
            Text("Up to \(distancePickerVM.miles, specifier: "%.0f")miles (\(distancePickerVM.convertMilesToKm(miles: distancePickerVM.miles))km) away")
                .font(.roboto(.bold, size: 18))
                .foregroundStyle(Color.black)
        }
    }
    
    private var distancePickTitle: some View {
        HStack {
            Image(systemName: "xmark")
                .resizable()
                .frame(width: 32, height: 32)
                .onTapGesture {
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(.black)
            Spacer()
            Image(systemName: "mappin.and.ellipse")
                .resizable()
                .frame(width: 35, height: 35)
                .foregroundColor(.black)
            Text("Search Range")
                .foregroundColor(.black)
                .font(.roboto(.bold, size: 28))
            Spacer()

        }
    }
    
}

//#Preview {
//    DistancePickerView()
//}
