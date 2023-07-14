//
//  ListCellView.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 7/13/23.
//

import Foundation
import SwiftUI

struct ListCellView: View {
    let index: Int
    let text: String
    let backgroundColor: Color
    let foregroundColor: Color
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5)
                .background(backgroundColor)
                .foregroundColor(foregroundColor)
            VStack {
                Text(text)
                    .foregroundColor(.black)
                    .listRowBackground(
                        RoundedRectangle(cornerRadius: 5)
                            .background(.clear)
                            .foregroundColor(.white)
                            .padding(
                                EdgeInsets(
                                    top: 2,
                                    leading: 2,
                                    bottom: 2,
                                    trailing: 2
                                )
                            )
                    )
            }
        }
    }
}
