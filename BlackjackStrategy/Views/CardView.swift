import SwiftUI

struct CardView: View {
    let card: Card
    var height: CGFloat = 100

    private var width: CGFloat {
        height * 0.7
    }

    private var valueFontSize: CGFloat {
        height * 0.32
    }

    private var symbolFontSize: CGFloat {
        height * 0.24
    }

    var body: some View {
        VStack(spacing: height * 0.04) {
            Text(card.displayValue)
                .font(.system(size: valueFontSize, weight: .bold, design: .rounded))
                .foregroundStyle(card.suit.color)

            Image(systemName: card.suit.sfSymbol)
                .font(.system(size: symbolFontSize))
                .foregroundStyle(card.suit.color)
        }
        .frame(width: width, height: height)
        .background(.white)
        .cornerRadius(height * 0.08)
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
}
