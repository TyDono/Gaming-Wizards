//
//  ShakeEffect.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 5/24/23.
//

import SwiftUI

struct ShakeEffect: GeometryEffect {
    
    var position: CGFloat
    var animatableData: CGFloat {
        get { position }
        set { position = newValue }
    }
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        let translationX = -30 * sin(position * 2 * .pi)
        return ProjectionTransform(CGAffineTransform(translationX: translationX, y: 0))
    }
    
    init(shakes: Int) {
        position = CGFloat(shakes)
    }
}
