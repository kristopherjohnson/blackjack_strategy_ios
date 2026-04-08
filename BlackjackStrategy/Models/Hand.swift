import Foundation

/// A blackjack hand consisting of two or more cards.
struct Hand {
    /// The cards in this hand.
    let cards: [Card]

    /// Whether the hand is a pair (two cards of the same rank).
    var isPair: Bool {
        cards.count == 2 && cards[0].rank == cards[1].rank
    }

    /// Whether the hand is soft (contains an Ace that can count as 11 without busting).
    var isSoft: Bool {
        // Soft if an Ace can be counted as 11 without busting
        hardTotal <= 11 && cards.contains { $0.rank == .ace }
    }

    /// Total with all Aces counted as 1.
    var hardTotal: Int {
        cards.reduce(0) { sum, card in
            sum + (card.rank == .ace ? 1 : card.blackjackValue)
        }
    }

    /// Optimal total, counting one Ace as 11 if it doesn't cause a bust.
    var bestTotal: Int {
        // Use soft total (Ace = 11) if it doesn't bust
        isSoft ? hardTotal + 10 : hardTotal
    }

    /// Whether this is a natural blackjack (two cards totaling 21).
    var isBlackjack: Bool {
        cards.count == 2 && bestTotal == 21
    }

    /// Lookup key for the strategy table, based on hand type.
    ///
    /// Returns a pair key like `"8,8"`, a soft key like `"A,6"`, or a hard total like `"16"`.
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

    /// Generates a random two-card hand, re-dealing until the result is not a blackjack.
    static func randomTwoCard() -> Hand {
        var hand: Hand
        repeat {
            hand = Hand(cards: [Card.random(), Card.random()])
        } while hand.isBlackjack
        return hand
    }
}
