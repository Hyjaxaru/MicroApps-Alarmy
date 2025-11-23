//
//  luminocity.swift
//  TrainticketsApp
//
//  Created by Noah Albrock on 20/07/2025.
//

import SwiftUI

extension Color {
    func luminance() -> Double {
        // 1. Convert SwiftUI Color to UIColor
        let uiColor = UIColor(self)

        // 2. Extract RGB values
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: nil)

        // 3. Compute luminance.
        return 0.2126 * Double(red) + 0.7152 * Double(green) + 0.0722 * Double(blue)
    }
    
    func isLight() -> Bool {
        return luminance() > 0.5
    }

    func adaptedTextColor() -> Color {
        return isLight() ? Color.black : Color.white
    }
}
