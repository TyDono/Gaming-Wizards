//
//  DistancePickerView.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 9/28/23.
//

import SwiftUI

struct DistancePickerView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var distancePickerVM: DistancePickerViewModel
    
    init(distancePickerVM: DistancePickerViewModel) {
        _distancePickerVM = StateObject(wrappedValue: distancePickerVM)
    }
    
    var body: some View {
        distancePicker
    }
    
    private var distancePicker: some View {
        VStack {
            HStack {
                Spacer()
                Image(systemName: "mappin.and.ellipse")
                    .resizable()
                    .frame(width: 35, height: 35)
                    .foregroundColor(.black)
                Text("Search Range")
                    .foregroundColor(.black)
                    .font(.roboto(.bold, size: 28))
                Spacer()
                Image(systemName: "xmark")
                    .resizable()
                    .frame(width: 32, height: 32)
                    .onTapGesture {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(.black)
            }
            .padding()
            Text("How far are you looking for?")
                .font(.roboto(.bold, size: 18))
                .foregroundStyle(Color.lightGrey)
            Text("Up to \(distancePickerVM.miles, specifier: "%.0f")miles (\(distancePickerVM.convertMilesToKm(miles: distancePickerVM.miles))km) away")
                .font(.roboto(.bold, size: 18))
                .foregroundStyle(Color.black)
            
            Slider(value: Binding(
                            get: {
                                self.distancePickerVM.miles
                            },
                            set: { newValue in
                                self.distancePickerVM.miles = self.distancePickerVM.mapExponential(value: newValue)
                            }
                        ), in: 1...1000)
                        .padding()
        }
    }
    
}

//#Preview {
//    DistancePickerView()
//}
