//
//  CustomNavigationLeadingBarItem.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 10/18/23.
//

import SwiftUI

struct CustomNavigationLeadingBarItem: View {
    
    var leadingButtonAction: (() -> Void)?
    @Binding var leadingButtonString: String?
    
    var body: some View {
        
        HStack {
            if let leadingButtonString = leadingButtonString, let leadingButtonAction = leadingButtonAction {
                Button(action: leadingButtonAction) {
                    Image(systemName: leadingButtonString)
                        .imageScale(.large)
                        .foregroundStyle(Color.blue)
                }
            }
        }
        .padding(.leading, 5)
        
    }
}

