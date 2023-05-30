//
//  ShakeEffect.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 5/24/23.
//

import Foundation
import SwiftUI


struct ShakeEffect: GeometryEffect {
    var travelDistance: CGFloat = 6
    var isShaking: Bool
    var amount: CGFloat = 10
    var numberOfShakes: CGFloat = 4
    var shakeCount: CGFloat
    var animatableData: CGFloat {
        get { amount }
        set { amount = newValue }
    }

    func effectValue(size: CGSize) -> ProjectionTransform {
        if isShaking {
//            let progress = CGFloat(shakeCount) * 2 - abs(amount)
//            let translationX = progress * amount
            let progress = amount * sin(amount)
            let translationX = progress * amount
//            let translationX = amount * sin(amount)
            return ProjectionTransform(CGAffineTransform(translationX: translationX, y: 0))
        } else {
            return ProjectionTransform(CGAffineTransform.identity)
        }
    }
    
}
