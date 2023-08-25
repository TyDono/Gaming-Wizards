//
//  ViewExtension.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 6/29/22.
//

import SwiftUI

extension View {
    
//    func shakingAnimation(isShaking: Bool, shakeCount: CGFloat) -> some View {
//        self.modifier(ShakeEffect(isShaking: isShaking, shakeCount: shakeCount))
//    }
    
    func customPickerBackground(selected: Bool) -> some View {
        self
            .background(selected ? Color(.systemGray6) : Color(.systemGray4))
            .cornerRadius(8)
    }
    
    func hideKeyboard() {
        #if canImport(UIKit)
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        #endif
    }
    
    func hideNavigationBar() -> some View {
        modifier(HideNavigationBarModifier())
    }
    
    func glow(color: Color = .red, radius: CGFloat = 20) -> some View {
        self
            .shadow(color: color, radius: radius / 3)
            .shadow(color: color, radius: radius / 3)
            .shadow(color: color, radius: radius / 3)
    }
    
}
