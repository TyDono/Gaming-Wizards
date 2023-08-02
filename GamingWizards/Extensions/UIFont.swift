//
//  UIFont.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 10/18/22.
//

import SwiftUI

import SwiftUI

extension Font {
    enum RobotoFont {
        case regular
        case semibold
        case bold
        case custom(String)

        var value: String {
            switch self {
            case .regular:
                return "Regular"
            case .semibold:
                return "Semibold"
            case .bold:
                return "Bold"
            case .custom(let name):
                return name
            }
        }
    }

    enum globalFontType {
        case bold
        case luminari

        var value: String {
            switch self {
            case .bold:
                return "bold"
            case .luminari:
                return Constants.luminariRegularFontIdentifier
            }
        }
    }

    static func roboto(_ type: RobotoFont, size: CGFloat = 20) -> Font {
        switch type {
        case .regular, .custom(_):
            return .custom("Roboto-\(type.value)", size: size)
        case .semibold, .bold:
            return .custom("Roboto-\(type.value)", size: size, relativeTo: .headline)
        }
    }

    static func globalFont(_ type: globalFontType, size: CGFloat = 20) -> Font {
        return .custom(type.value, size: size)
    }

    
    /*
    /// Create a font with the large title text style.
        public static var largeTitle: Font {
            return Font.custom(Constants.luminariRegularFontIdentifier, size: UIFont.preferredFont(forTextStyle: .largeTitle).pointSize)
        }

        /// Create a font with the title text style.
        public static var title: Font {
            return Font.custom(Constants.luminariRegularFontIdentifier, size: UIFont.preferredFont(forTextStyle: .title1).pointSize)
        }

        /// Create a font with the headline text style.
        public static var headline: Font {
            return Font.custom(Constants.luminariRegularFontIdentifier, size: UIFont.preferredFont(forTextStyle: .headline).pointSize)
        }

        /// Create a font with the subheadline text style.
        public static var subheadline: Font {
            return Font.custom(Constants.luminariRegularFontIdentifier, size: UIFont.preferredFont(forTextStyle: .subheadline).pointSize)
        }

        /// Create a font with the body text style.
        public static var body: Font {
               return Font.custom(Constants.luminariRegularFontIdentifier, size: UIFont.preferredFont(forTextStyle: .body).pointSize)
           }

        /// Create a font with the callout text style.
        public static var callout: Font {
               return Font.custom(Constants.luminariRegularFontIdentifier, size: UIFont.preferredFont(forTextStyle: .callout).pointSize)
           }

        /// Create a font with the footnote text style.
        public static var footnote: Font {
               return Font.custom(Constants.luminariRegularFontIdentifier, size: UIFont.preferredFont(forTextStyle: .footnote).pointSize)
           }

        /// Create a font with the caption text style.
        public static var caption: Font {
               return Font.custom(Constants.luminariRegularFontIdentifier, size: UIFont.preferredFont(forTextStyle: .caption1).pointSize)
           }

    public static func system(size: CGFloat, weight: Font.Weight = .regular, design: Font.Design = .default) -> Font {
        var font = Constants.luminariRegularFontIdentifier
        switch weight {
        case .bold: font = Constants.luminariRegularFontIdentifier
        case .heavy: font = Constants.luminariRegularFontIdentifier
        case .light: font = Constants.luminariRegularFontIdentifier
        case .medium: font = Constants.luminariRegularFontIdentifier
        case .semibold: font = Constants.luminariRegularFontIdentifier
        case .thin: font = Constants.luminariRegularFontIdentifier
        case .ultraLight: font = Constants.luminariRegularFontIdentifier
        default: break
        }
        return Font.custom(font, size: size)
    }
     */
    
}
