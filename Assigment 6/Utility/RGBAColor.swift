//
//  RGBAColor.swift
//  Assigment 6
//
//  Created by Dennis van den Berg on 25/05/2023.
//

import SwiftUI

struct RGBAColor: Codable, Equatable, Hashable {
    let red: Double
    let green: Double
    let blue: Double
    let alpha: Double
}

extension Color {
    init(rgbaColor rgba: RGBAColor) {
        self.init(.sRGB, red: rgba.red, green: rgba.green, blue: rgba.blue, opacity: rgba.alpha)
    }
}

extension RGBAColor {
    init(color: Color) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        if let cgColor = color.cgColor {
            UIColor(cgColor: cgColor).getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        }
        self.init(red: Double(red), green: Double(green), blue: Double(blue), alpha: Double(alpha))
    }
}

extension EmojiTheme {
    var color: Color {
        get {
            return Color(rgbaColor: self.rgbaColor)
        }
        set {
            rgbaColor = RGBAColor(color: newValue)
        }
    }
    
    init(id: Int, name: String, color: Color, pairs: Int, emojis: String) {
        self.id = id
        self.name = name
        self.rgbaColor = RGBAColor(color: color)
        self.emojis = emojis
        self.pairs = pairs
    }
}
