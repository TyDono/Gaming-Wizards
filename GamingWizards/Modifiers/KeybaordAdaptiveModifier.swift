//
//  KeybaordAdaptiveModifier.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 6/29/22.
//

import Combine
import SwiftUI

struct KeyboardAdaptive: ViewModifier {
    @State private var bottomPadding: CGFloat = 0

    func body(content: Content) -> some View {
        GeometryReader { geometry in
            content
                .padding(.bottom, bottomPadding)
                .frame(width: geometry.size.width, height: geometry.size.height)
                .onReceive(Publishers.keyboardHeight) { keyboardHeight in
                    let keyboardTop = geometry.frame(in: .global).height - keyboardHeight
                    let focusedTextInputBottom = UIResponder.currentFirstResponder?.globalFrame?.maxY ?? 0
                    bottomPadding = max(0, focusedTextInputBottom - keyboardTop - geometry.safeAreaInsets.bottom)
            }
                .animation(.easeOut, value: 0.16)
        }
    }
}

extension View {
    @ViewBuilder
    func keyboardAdaptive() -> some View {
        if #available(iOS 14, *) {
            ModifiedContent(content: self, modifier: KeyboardAdaptive())
                .ignoresSafeArea(.keyboard)
        } else {
            ModifiedContent(content: self, modifier: KeyboardAdaptive())
        }
    }
}
