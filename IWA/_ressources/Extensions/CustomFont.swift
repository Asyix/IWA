//
//  CustomFont.swift
//  IWA
//
//  Created by etud on 14/03/2025.
//

import SwiftUI

extension Font {
    static func poppins(fontStyle: Font.TextStyle = .body, fontWeight: Weight = .regular, isItalic: Bool = false) -> Font {
        return Font.custom(CustomFont(weight: fontWeight, isItalic: isItalic).rawValue, size: fontStyle.size)
    }
}

extension Font.TextStyle {
    var size: CGFloat {
        switch self {
        case .largeTitle: return 34
        case .title: return 28
        case .title2: return 22
        case .title3: return 20
        case .headline: return 17
        case .subheadline: return 15
        case .body: return 16
        case .callout: return 16
        case .footnote: return 13
        case .caption: return 12
        case .caption2: return 11
        @unknown default: return 16
        }
    }
}

enum CustomFont: String {
    case extraLight = "Poppins-ExtraLight"
    case thinItalic = "Poppins-ThinItalic"
    case extraLightItalic = "Poppins-ExtraLightItalic"
    case boldItalic = "Poppins-BoldItalic"
    case light = "Poppins-Light"
    case medium = "Poppins-Medium"
    case semiBoldItalic = "Poppins-SemiBoldItalic"
    case extraBoldItalic = "Poppins-ExtraBoldItalic"
    case extraBold = "Poppins-ExtraBold"
    case blackItalic = "Poppins-BlackItalic"
    case regular = "Poppins-Regular"
    case lightItalic = "Poppins-LightItalic"
    case bold = "Poppins-Bold"
    case black = "Poppins-Black"
    case thin = "Poppins-Thin"
    case semiBold = "Poppins-SemiBold"
    case italic = "Poppins-Italic"
    case mediumItalic = "Poppins-MediumItalic"

    init(weight: Font.Weight, isItalic: Bool) {
        switch weight {
        case .ultraLight:
            self = isItalic ? .extraLightItalic : .extraLight
        case .thin:
            self = isItalic ? .thinItalic : .thin
        case .light:
            self = isItalic ? .lightItalic : .light
        case .regular:
            self = isItalic ? .italic : .regular
        case .medium:
            self = isItalic ? .mediumItalic : .medium
        case .semibold:
            self = isItalic ? .semiBoldItalic : .semiBold
        case .bold:
            self = isItalic ? .boldItalic : .bold
        case .heavy:
            self = isItalic ? .extraBoldItalic : .extraBold
        case .black:
            self = isItalic ? .blackItalic : .black
        default:
            self = .regular
        }
    }
}
