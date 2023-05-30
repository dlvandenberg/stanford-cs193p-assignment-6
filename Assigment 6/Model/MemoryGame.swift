//
//  MemoryGame.swift
//  Assigment 6
//
//  Created by Dennis van den Berg on 24/05/2023.
//

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable {
    private(set) var cards: [Card]
    private var indexOfOneAndOnlyFaceUpCard: Int?
    {
        get { cards.indices.filter({ cards[$0].isFaceUp }).oneAndOnly }
        set { cards.indices.forEach { cards[$0].isFaceUp = ($0 == newValue) } }
    }
    
    private(set) var score: Int
    private var alreadySeenCardIndices: Set<Int>
    private var datetimeOnLastTurn: Date?
    
    init(numberOfPairsOfCards: Int, createCardContent: (Int) -> CardContent) {
        cards = []
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = createCardContent(pairIndex)
            cards.append(Card(id: (pairIndex*2), content: content))
            cards.append(Card(id: (pairIndex*2+1), content: content))
        }
        cards.shuffle()
        score = 0
        alreadySeenCardIndices = Set()
    }
    
    private func getBonusMultiplier(for card: Card, and matchingCard: Card) -> Double {
        let bonus = 10 * (card.bonusRemaining + matchingCard.bonusRemaining)
        print("Calculating bonus time for \(card.bonusRemaining) and \(matchingCard.bonusRemaining) -> \(bonus)")
        return bonus
    }
    
    mutating func chooseCard(_ card: Card) {
        
        if let cardIndex = cards.firstIndex(where: { $0.id == card.id }),
           !cards[cardIndex].isFaceUp,
           !cards[cardIndex].isMatched
        {
            
            if let potentialMatchIndex = indexOfOneAndOnlyFaceUpCard {
                if cards[cardIndex].content == cards[potentialMatchIndex].content {
                    cards[cardIndex].isMatched = true
                    cards[potentialMatchIndex].isMatched = true
                    score += 2 * Int(getBonusMultiplier(for: cards[cardIndex], and: cards[potentialMatchIndex]))
                    print("Found a match!")
                } else {
                    print("Mismatch")
                    let alreadySeenCards = alreadySeenCardIndices.filter({ $0 == cardIndex || $0 == potentialMatchIndex }).count
                    if alreadySeenCards > 0 {
                        print("\(alreadySeenCards) involved in mismatch has been seen already.")
                        score -= alreadySeenCards * Int(getBonusMultiplier(for: cards[cardIndex], and: cards[potentialMatchIndex]) / 3)
                    }
                    alreadySeenCardIndices.insert(potentialMatchIndex)
                    alreadySeenCardIndices.insert(cardIndex)
                }
                cards[cardIndex].isFaceUp = true
            } else {
                indexOfOneAndOnlyFaceUpCard = cardIndex
            }
        }
    }
    
    func calculateBonus(withSecondsSinceLastCardTurn interval: TimeInterval?) -> Double {
        Double.maximum(10 - (interval ?? 9), 1)
    }
    
    struct Card: Identifiable {
        var id: Int
        var isFaceUp = false {
            didSet {
                if isFaceUp {
                    startUsingBonusTime()
                } else {
                    stopUsingBonusTime()
                }
            }
        }
        var isMatched = false {
            didSet {
                if isMatched {
                    stopUsingBonusTime()
                }
            }
        }
        let content: CardContent
        
        // MARK: Bonus time
        var bonusTimeLimit: TimeInterval = 6
        // how long this card has even been face up
        private var faceUpTime: TimeInterval {
            if let lastFaceUpDate = self.lastFaceUpDate {
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
            } else {
                return pastFaceUpTime
            }
        }
        // last time this card was turned face up
        var lastFaceUpDate: Date?
        // accumulated time this card has been face up
        var pastFaceUpTime: TimeInterval = 0
        // how much time left before bonus runs out
        var bonusTimeRemaining: TimeInterval {
            max(0, bonusTimeLimit - faceUpTime)
        }
        // percentage of bonus time remaining
        var bonusRemaining: Double {
            (bonusTimeLimit > 0 && bonusTimeRemaining > 0) ? bonusTimeRemaining/bonusTimeLimit : 0
        }
        // whether card was matched during bonus time
        var hasEarnedBonus: Bool {
            isMatched && bonusTimeRemaining > 0
        }
        // whether we are currently face up, unmatched
        var isConsumingBonusTime: Bool {
            isFaceUp && !isMatched && bonusTimeRemaining > 0
        }
        
        // Called when the card transitions to face up state
        private mutating func startUsingBonusTime() {
            if isConsumingBonusTime, lastFaceUpDate == nil {
                lastFaceUpDate = Date()
            }
        }
        
        // Called when card goes back down (or is matched)
        private mutating func stopUsingBonusTime() {
            pastFaceUpTime = faceUpTime
            self.lastFaceUpDate = nil
        }
    }
}
