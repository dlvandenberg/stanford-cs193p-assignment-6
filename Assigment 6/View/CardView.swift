//
//  CardView.swift
//  Assigment 6
//
//  Created by Dennis van den Berg on 24/05/2023.
//

import SwiftUI

struct CardView: View {
    private let card: EmojiMemoryGame.Card
    
    @State private var animatedBonusRemaining: Double = 0
    
    init(_ card: EmojiMemoryGame.Card) {
        self.card = card
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Group {
                    if card.isConsumingBonusTime {
                        Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: (1-animatedBonusRemaining)*359.9-90))
                        .onAppear {
                            animatedBonusRemaining = card.bonusRemaining
                            withAnimation(.linear(duration: card.bonusTimeRemaining)) {
                                animatedBonusRemaining = 0
                            }
                        }
                    } else {
                        Pie(startAngle: Angle(degrees: 0-90),
                            endAngle: Angle(degrees: (1-card.bonusRemaining)*359.9-90))
                        
                    }
                }
                .padding(DrawingConstants.piePadding)
                .opacity(DrawingConstants.pieOpacity)
                
                Text(card.content)
                    .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
                    .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false), value: card.isMatched)
                    .font(Font.system(size: 32))
                    .scaleEffect(scale(thatFits: geometry.size))
                    
            }
            .cardify(isFaceUp: card.isFaceUp)
        }
    }
    
    private func scale(thatFits size: CGSize) -> CGFloat {
        min(size.width, size.height) / (DrawingConstants.fontSize / DrawingConstants.fontScale)
    }
    
    private func font(in size: CGSize) -> Font {
        .system(size: min(size.width, size.height) * DrawingConstants.fontScale)
    }
    
    private struct DrawingConstants {
        static let pieOpacity: CGFloat = 0.5
        static let piePadding: CGFloat = 5
        static let fontScale: CGFloat = 0.6
        static let fontSize: CGFloat = 32
    }
}
