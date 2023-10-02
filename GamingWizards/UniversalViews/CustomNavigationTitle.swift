//
//  CustomNavigationTitle.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 10/2/23.
//

import Foundation
import SwiftUI

struct CustomNavigationTitle: View {
    @Binding var titleImageSystemName: String?
    @Binding var titleText: String?
    
    var body: some View {
        HStack {
            Image(systemName: titleImageSystemName ?? "")
                .imageScale(.large)
            Text(titleText ?? "")
                .font(.globalFont(.luminari, size: 28))
                .foregroundStyle(Color.black)
        }
    }
    
}
