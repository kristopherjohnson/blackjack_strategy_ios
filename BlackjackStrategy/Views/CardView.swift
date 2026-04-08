import SwiftUI

/// Renders a single playing card with rank and suit, sized proportionally to the given height.
struct CardView: View {
    /// The card to display.
    let card: Card

    /// The card's height in points. Width is derived as `height * 0.7`.
    var height: CGFloat = 100

    /// Computed card width maintaining a 0.7 aspect ratio.
    private var width: CGFloat {
        height * 0.7
    }

    /// Font size for the rank label, scaled to card height.
    private var valueFontSize: CGFloat {
        height * 0.32
    }

    /// Font size for the suit symbol, scaled to card height.
    private var symbolFontSize: CGFloat {
        height * 0.24
    }

    var body: some View {
        VStack(spacing: height * 0.04) {
            Text(card.displayValue)
                .font(.system(size: valueFontSize, weight: .bold, design: .rounded))
                .foregroundStyle(card.suit.color)

            Text(card.suit.symbol)
                .font(.system(size: symbolFontSize))
                .foregroundStyle(card.suit.color)
        }
        .frame(width: width, height: height)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: height * 0.08))
        .shadow(radius: 2)
    }
}

#Preview {
    HStack {
        CardView(card: Card(rank: .ace, suit: .spades))
        CardView(card: Card(rank: .king, suit: .hearts))
        CardView(card: Card(rank: .seven, suit: .diamonds))
    }
    .padding()
    .background(Color.green.opacity(0.7))
    .preferredColorScheme(.dark)
}
