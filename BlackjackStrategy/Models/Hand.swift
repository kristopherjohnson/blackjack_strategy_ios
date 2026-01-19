import Foundation

struct Hand {
    let cards: [Card]

    var isPair: Bool {
        cards.count == 2 && cards[0].rank == cards[1].rank
    }

    var isSoft: Bool {
        // Soft if an Ace can be counted as 11 without busting
        hardTotal <= 11 && cards.contains { $0.rank == .ace }
    }

    var hardTotal: Int {
        cards.reduce(0) { sum, card in
            sum + (card.rank == .ace ? 1 : card.blackjackValue)
        }
    }

    var bestTotal: Int {
        // Use soft total (Ace = 11) if it doesn't bust
        isSoft ? hardTotal + 10 : hardTotal
    }

    var isBlackjack: Bool {
        cards.count == 2 && bestTotal == 21
    }

    var strategyKey: String {
        if isPair {
            let value = cards[0].rank.strategyKey
            return "\(value),\(value)"
        } else if isSoft {
            // Non-ace total plus extra aces (counted as 1)
            var nonAceTotal = 0
            var aceCount = 0
            for card in cards {
                if card.rank == .ace {
                    aceCount += 1
                } else {
                    nonAceTotal += card.blackjackValue
                }
            }
            let otherValue = nonAceTotal + (aceCount - 1)
            return "A,\(otherValue)"
        } else {
            return "\(bestTotal)"
        }
    }

    static func randomTwoCard() -> Hand {
        var hand: Hand
        repeat {
            hand = Hand(cards: [Card.random(), Card.random()])
        } while hand.isBlackjack
        return hand
    }
}
