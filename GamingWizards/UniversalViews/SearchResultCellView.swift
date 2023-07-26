//
//  SearchResultCellView.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 7/12/23.
//

import Foundation
import SwiftUI

struct SearchResultCellView: View {
    let index: Int
    let text: String
    let isEmptyCell: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5)
                .background(.clear)
                .foregroundColor(isEmptyCell ? .clear : .white)
            VStack {
                Text(text)
                    .foregroundColor(.black)
                    .listRowBackground(
                        RoundedRectangle(cornerRadius: 5)
                            .background(.clear)
                            .foregroundColor(isEmptyCell ? .clear : .white)
                            .padding(
                                EdgeInsets(
                                    top: 2,
                                    leading: 2,
                                    bottom: 2,
                                    trailing: 2
                                )
                            )
                    )
                    .opacity(isEmptyCell ? 0 : 1)
                    .animation(Animation.easeInOut(duration: 0.5), value: text)
            }
        }
    }
}
