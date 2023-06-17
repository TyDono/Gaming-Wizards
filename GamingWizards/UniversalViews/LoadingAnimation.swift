//
//  LoadingAnimation.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 6/8/23.
//

import Foundation
import SwiftUI

struct LoadingAnimation: View {
    @Binding var loadingProgress: Double
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                ProgressView("Uploading...", value: loadingProgress, total: 100)
                    .progressViewStyle(CircularProgressViewStyle())
            }
            .frame(width: geometry.size.width / 2, height: geometry.size.width / 2)
            .background(Color.white.opacity(0.8))
            .cornerRadius(8)
            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
        }
    }
}
