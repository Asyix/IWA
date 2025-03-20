//
//  CustomColorTheme.swift
//  IWA
//
//  Created by etud on 14/03/2025.
//

import SwiftUI

extension Color {
    static var CPprimary: Color {
        Color(uiColor: UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? .black : .white
        })
    }
    static var CPsecondary: Color {
        Color(uiColor: UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? .white : .black
        })
    }
    
    static var BGPrimary: Color {
        Color(uiColor: UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? .darkGray : .white
        })
    }
    
    static var BGSecondary: Color {
        Color(uiColor: UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? .black : .systemGray5
        })
    }
    
    // Cool Palette Blue #4DA0FF
    static let CPBlue = Color(red: 0x4D / 255, green: 0xA0 / 255, blue: 0xFF / 255)
    
    // Cool Palette Lilas #BC84ED
    static let CPLilas = Color(red: 188 / 255, green: 132 / 255, blue: 237 / 255)
    
    // Cool Palette Purple #5B20B4
    static let CPPurple = Color(red: 91 / 255, green: 32 / 255, blue: 180 / 255)
    
    // Cool Palette Indigo #9891FF
    static let CPIndigo = Color(red: 152 / 255, green: 145 / 255, blue: 255 / 255)
    
    // Cool Palette Teal #00DAB5
    static let CPTeal = Color(red: 0 / 255, green: 218 / 255, blue: 181 / 255)
}


