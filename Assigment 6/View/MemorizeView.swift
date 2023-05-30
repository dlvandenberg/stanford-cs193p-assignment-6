//
//  MemorizeView.swift
//  Assigment 6
//
//  Created by Dennis van den Berg on 24/05/2023.
//

import SwiftUI

struct MemorizeView: View {
    @ObservedObject var game: EmojiMemoryGame
    @Namespace private var dealingNamespace
    
    var body: some View {
        VStack {
            cardsView
            scoreView
        }
        .navigationTitle(Text(game.theme.name))
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("New Game") {
                    withAnimation {
                        game.newGame()
                    }
                }
            }
        }
        .padding(.horizontal)
    }
    
    var cardsView: some View {
        AspectVGrid(items: game.cards, aspectRatio: DrawingConstants.cardAspectRatio) { card in
            if card.isMatched && !card.isFaceUp {
                Color.clear
            } else {
                CardView(card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .padding(4)
                    .transition(.asymmetric(insertion: .identity, removal: .scale))
                    .onTapGesture {
                        withAnimation {
                            game.choose(card)
                        }
                    }
                    .foregroundColor(game.theme.color)
            }
        }
        .foregroundColor(game.theme.color)
    }
    
    var scoreView: some View {
        HStack(alignment: .center) {
            Text("Score: \(game.score)")
        }
    }
    
    private struct DrawingConstants {
        static let cardAspectRatio: CGFloat = 2/3
    }
}


struct MemorizeView_Previews: PreviewProvider {
    static var previews: some View {
        let emojis = "🚙🚗🚘🚕🚖🏎🚚🛻🚛🚐🚓🚔🚑🚒🚀✈️🛫🛬🛩🚁🛸🚲🏍🛶⛵️🚤🛥🛳⛴🚢🚂🚝🚅🚆🚊🚉🚇🛺🚜"
        let game = EmojiMemoryGame(with: EmojiTheme(id: 0, name: "Preview", color: Color(cgColor: .init(red: 255, green: 0, blue: 0, alpha: 1)), pairs: emojis.count/2, emojis: emojis))
        MemorizeView(game: game)
            .preferredColorScheme(.dark)
    }
}
