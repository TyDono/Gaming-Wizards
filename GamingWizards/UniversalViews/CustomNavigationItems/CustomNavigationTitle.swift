//
//  CustomNavigationTitle.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 10/18/23.
//

import SwiftUI

struct CustomNavigationTitle: View {
    
    @Binding var titleImageSystemName: String?
    @Binding var titleText: String?
    
    var body: some View {
        
        HStack(alignment: .center) {
            if let titleImageSystemName = titleImageSystemName {
                Image(systemName: titleImageSystemName)
                    .imageScale(.large)
            }
            if let titleText = titleText {
                Text(titleText)
                    .font(.globalFont(.luminari, size: 28))
                    .foregroundStyle(Color.black)
            }
        }
        .padding()
        
    }
}

