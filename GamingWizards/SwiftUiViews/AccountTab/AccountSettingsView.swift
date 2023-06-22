//
//  AccountSettingsView.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 6/22/23.
//

import SwiftUI

struct AccountSettingsView: View {
    @StateObject private var accountSettingsViewModel = AccountSettingsViewModel()
    var body: some View {
        changeGlobalFontView
    }
    
    private var changeGlobalFontView: some View {
        Text("Current Font")
        // change fonts from normal and luminari. post mvp
    }
    
}

struct AccountSettings_Previews: PreviewProvider {
    static var previews: some View {
        AccountSettingsView()
    }
}
