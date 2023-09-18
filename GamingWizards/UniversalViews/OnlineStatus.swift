//
//  OnlineStatus.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 9/18/23.
//

import Foundation
import SwiftUI

struct OnlineStatus: View {
    var circleColor: Color
    var circleWidth: CGFloat
    var circleHeight: CGFloat
    
    var body: some View {
        VStack {
            HStack {
                Circle()
                    .foregroundColor(circleColor)
                    .frame(width: circleWidth, height: circleHeight)
            }
        }
    }
    
}
