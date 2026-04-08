import SwiftUI

/// The four standard playing card suits.
enum Suit: CaseIterable, Codable {
    case hearts, diamonds, clubs, spades

    /// Unicode character for the suit (e.g. "♠").
    var symbol: String {
        switch self {
        case .hearts: "♥"
        case .diamonds: "♦"
        case .clubs: "♣"
        case .spades: "♠"
        }
    }

    /// Display color: red for hearts/diamonds, black for clubs/spades.
    var color: Color {
        switch self {
        case .hearts, .diamonds: .red
        case .clubs, .spades: .black
        }
    }

    /// SF Symbols name for the filled suit icon.
    var sfSymbol: String {
        switch self {
        case .hearts: "suit.heart.fill"
        case .diamonds: "suit.diamond.fill"
        case .clubs: "suit.club.fill"
        case .spades: "suit.spade.fill"
        }
    }
}

/// Standard playing card ranks, with raw values used for ordering.
enum Rank: Int, CaseIterable, Codable {
    case two = 2
    case three = 3
    case four = 4
    case five = 5
    case six = 6
    case seven = 7
    case eight = 8
    case nine = 9
    case ten = 10
    case jack = 11
    case queen = 12
    case king = 13
    case ace = 14

    /// Short display string for the rank (e.g. "A", "K", "10", "2").
    var displayValue: String {
        switch self {
        case .two, .three, .four, .five, .six, .seven, .eight, .nine:
            "\(rawValue)"
        case .ten: "10"
        case .jack: "J"
        case .queen: "Q"
        case .king: "K"
        case .ace: "A"
        }
    }

    /// Blackjack point value. Face cards are 10, Ace defaults to 11.
    var blackjackValue: Int {
        switch self {
        case .two, .three, .four, .five, .six, .seven, .eight, .nine:
            rawValue
        case .ten, .jack, .queen, .king:
            10
        case .ace:
            11
        }
    }

    /// Key used for strategy table lookups. Face cards map to "10", Ace to "A".
    var strategyKey: String {
        switch self {
        case .ace: "A"
        case .ten, .jack, .queen, .king: "10"
        default: "\(blackjackValue)"
        }
    }
}

/// A single playing card with a rank and suit.
struct Card: Equatable, Identifiable {
    /// The card's rank (two through ace).
    let rank: Rank

    /// The card's suit (hearts, diamonds, clubs, or spades).
    let suit: Suit

    /// Unique identifier combining rank display and suit symbol (e.g. "A♠").
    var id: String {
        "\(rank.displayValue)\(suit.symbol)"
    }

    /// Short display string for the rank (e.g. "A", "K", "10").
    var displayValue: String {
        rank.displayValue
    }

    /// Blackjack point value for this card.
    var blackjackValue: Int {
        rank.blackjackValue
    }

    /// Generates a card with a uniformly random rank and suit.
    static func random() -> Card {
        Card(rank: Rank.allCases.randomElement()!, suit: Suit.allCases.randomElement()!)
    }
}
