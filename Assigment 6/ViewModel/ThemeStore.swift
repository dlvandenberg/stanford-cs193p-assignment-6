//
//  ThemeStore.swift
//  Assigment 6
//
//  Created by Dennis van den Berg on 25/05/2023.
//

import Foundation

class ThemeStore: ObservableObject {
    let name: String
    
    @Published var themes = [EmojiTheme]() {
        didSet {
            storeInUserDefaults()
        }
    }
    
    init(named name: String) {
        self.name = name
        restoreFromUserDefaults()
        
        if themes.isEmpty {
            insertTheme(named: "Weather", color: RGBAColor(red: 1, green: 0, blue: 0, alpha: 1), pairs: 6, emojis: "☀️🌤️⛅️☁️🌦️🌧️🌩️")
            insertTheme(named: "Transport", color: RGBAColor(red: 0, green: 0, blue: 1, alpha: 1), pairs: 7, emojis: "🚗🚕🚙🚌🚎🚓🚒🚑")
            insertTheme(named: "Animals", color: RGBAColor(red: 0.2, green: 0.6, blue: 0.6, alpha: 1), pairs: 5, emojis: "🐶🐱🐭🦊🐻🐼")
            insertTheme(named: "Flags", color: RGBAColor(red: 1, green: 0.4, blue: 0.4, alpha: 1), pairs: 10, emojis: "🏴‍☠️🏁🏳️‍🌈🏳️‍⚧️🇺🇳🇦🇫🇨🇦🇱🇺🇱🇧🇱🇷🇳🇦🇳🇴🎌🇬🇱🇩🇪🇬🇮")
            insertTheme(named: "Food", color: RGBAColor(red: 0.2, green: 0.6, blue: 0.2, alpha: 1), pairs: 8, emojis: "🍔🍟🫑🍒🍏🍓🍖🥐🥞")
            insertTheme(named: "Sports", color: RGBAColor(red: 0.9, green: 0.7, blue: 0.6, alpha: 1), pairs: 9, emojis: "⚽️🏀🏈⚾️🥎🏉🥏🎱🏏🏓🏒🏹🥊")
        }
    }
}

// MARK: Intents
extension ThemeStore {
    func theme(at index: Int) -> EmojiTheme {
        let safeIndex = min(max(index, 0), themes.count - 1)
        return themes[safeIndex]
    }
    
    func removeTheme(at index: Int) -> Int {
        if themes.count > 1, themes.indices.contains(index) {
            themes.remove(at: index)
        }
        return index % themes.count
    }
    
    func insertTheme(named name: String, color: RGBAColor? = nil, pairs: Int? = nil, emojis: String? = nil, at index: Int = 0) {
        let unique = (themes.max(by: { $0.id < $1.id })?.id ?? 0) + 1
        let theme = EmojiTheme(id: unique, name: name, color: color ?? RGBAColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0), pairs: pairs ?? 2, emojis: emojis ?? "")
        let safeIndex = min(max(index, 0), themes.count)
        themes.insert(theme, at: safeIndex)
    }
}

// MARK: Persistence
extension ThemeStore {
    private var userDefaultsKey: String {
        "ThemeStore:" + name
    }
    
    private func storeInUserDefaults() {
        let jsonData = try? JSONEncoder().encode(themes)
        UserDefaults.standard.set(jsonData, forKey: userDefaultsKey)
    }
    
    private func restoreFromUserDefaults() {
        if let jsonData = UserDefaults.standard.data(forKey: userDefaultsKey),
           let decodedThemes = try? JSONDecoder().decode([EmojiTheme].self, from: jsonData) {
            themes = decodedThemes
        }
    }
}

struct EmojiTheme: Identifiable, Codable, Hashable {
    var id: Int
    var name: String
    var rgbaColor: RGBAColor
    var pairs: Int
    var emojis: String
    
    fileprivate init(id: Int, name: String, color: RGBAColor, pairs: Int, emojis: String) {
        self.id = id
        self.name = name
        self.rgbaColor = color
        self.emojis = emojis
        self.pairs = pairs
    }
}
