//
//  EmojiMemoryGame.swift
//  Assigment 6
//
//  Created by Dennis van den Berg on 24/05/2023.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    typealias Card = MemoryGame<String>.Card
    
    static func createMemoryGame(with theme: EmojiTheme) -> MemoryGame<String> {
        var numOfPairs = theme.pairs
        if numOfPairs < theme.emojis.count {
            numOfPairs = theme.emojis.count
        }
        
        let shuffledEmojis = theme.emojis.shuffled().unique()
        
        return MemoryGame<String>(numberOfPairsOfCards: numOfPairs) { pairIndex in
            String(shuffledEmojis[pairIndex])
        }
    }
    
    @Published private var model: MemoryGame<String>
    @Published var theme: EmojiTheme {
        didSet {
            if theme != oldValue {
                model = EmojiMemoryGame.createMemoryGame(with: theme)
            }
        }
    }
    
    init(with theme: EmojiTheme) {
        self.theme = theme
        model = EmojiMemoryGame.createMemoryGame(with: theme)
    }
}

// MARK: - Available to View
extension EmojiMemoryGame {
    var cards: [MemoryGame<String>.Card] {
        model.cards
    }
    var score: Int {
        model.score
    }
}

// MARK: - Intent(s)
extension EmojiMemoryGame {
    func choose(_ card: MemoryGame<String>.Card) {
        model.chooseCard(card)
    }
    
    func newGame() {
        model = EmojiMemoryGame.createMemoryGame(with: theme)
    }
}
