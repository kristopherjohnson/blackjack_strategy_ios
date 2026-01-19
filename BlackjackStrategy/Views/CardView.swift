import SwiftUI

struct CardView: View {
    let card: Card

    var body: some View {
        VStack(spacing: 4) {
            Text(card.displayValue)
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundStyle(card.suit.color)

            Image(systemName: card.suit.sfSymbol)
                .font(.system(size: 24))
                .foregroundStyle(card.suit.color)
        }
        .frame(width: 70, height: 100)
        .background(.white)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(.gray.opacity(0.5), lineWidth: 1)
        )
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
