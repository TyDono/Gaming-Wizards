//
//  IsPayToPlaySearchSettingsView.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 10/9/23.
//

import SwiftUI

struct IsPayToPlaySearchSettingsView: View {
    @StateObject private var isPayToPlaySearchSettingsVM: IsPayToPlaySearchSettingsViewModel
    
    init(
        isPayToPlaySearchSettingsVM: IsPayToPlaySearchSettingsViewModel
    ) {
        self._isPayToPlaySearchSettingsVM = StateObject(wrappedValue: isPayToPlaySearchSettingsVM)
    }
    
    var body: some View {
        VStack {
            HStack(spacing: 10) {
                Image(systemName: isPayToPlaySearchSettingsVM.isPayToPlay ? "dollarsign" : "dice")
                    .font(.system(size: 20))
                Text(isPayToPlaySearchSettingsVM.isPayToPlay ? "Pay to Play" : "Free to Play")
                    .font(.system(size: 20))
                Spacer()
                Toggle(isOn: $isPayToPlaySearchSettingsVM.isPayToPlay) {
                    
                }
            }
            
            .onChange(of: isPayToPlaySearchSettingsVM.isPayToPlay) { newIsPayToPlayValue in
                isPayToPlaySearchSettingsVM.saveIsPayToPlaySettings(isPayToPlay: newIsPayToPlayValue)
            }
        } .onAppear {
            isPayToPlaySearchSettingsVM.changeIsPayToPlay()
        }
        
    }
    
}
