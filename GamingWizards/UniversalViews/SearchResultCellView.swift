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
                .padding(
                    EdgeInsets(
                        top: -6,
                        leading: 2,
                        bottom: -6,
                        trailing: 2
                    )
                )
                .foregroundColor(isEmptyCell ? .clear : .white)
                .animation(Animation.easeInOut(duration: 0.7), value: text)
            VStack {
                Text(text)
                    .foregroundColor(.black)
            }
        }
    }
}
