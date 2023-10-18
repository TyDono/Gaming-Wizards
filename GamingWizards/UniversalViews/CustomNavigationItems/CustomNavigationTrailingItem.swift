//
//  CustomNavigationTrailingItem.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 10/18/23.
//

import SwiftUI

struct CustomNavigationTrailingItem: View {
    
    var trailingButtonAction: (() -> Void)?
    @Binding var trailingButtonString: String?
    
    var body: some View {
        HStack {
            Spacer().frame(width: 5)
            if let trailingButtonString = trailingButtonString, let trailingButtonAction = trailingButtonAction {
                Button(action: trailingButtonAction) {
                    Image(systemName: trailingButtonString)
                        .imageScale(.large)
                        .foregroundStyle(Color.blue)
                }
            }
        }
        .padding(.trailing, 5)
    }
}

