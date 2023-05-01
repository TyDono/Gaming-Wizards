//
//  UIFont.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 10/18/22.
//

import Foundation
import SwiftUI

extension Font {
    
    enum RobotoFont {
        case semibold
        case custom(String)
        
        var value: String {
            switch self {
            case .semibold:
                return "Semibold"
                
            case .custom(let name):
                return name
            }
        }
    }
    
    static func roboto(_ type: RobotoFont, size: CGFloat = 20) -> Font {
        return .custom(type.value, size: size)
    }
}
