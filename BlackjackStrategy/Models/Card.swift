import SwiftUI

enum Suit: CaseIterable, Codable {
    case hearts, diamonds, clubs, spades

    var symbol: String {
        switch self {
        case .hearts: "♥"
        case .diamonds: "♦"
        case .clubs: "♣"
        case .spades: "♠"
        }
    }

    var color: Color {
        switch self {
        case .hearts, .diamonds: .red
        case .clubs, .spades: .black
        }
    }

    var sfSymbol: String {
        switch self {
        case .hearts: "suit.heart.fill"
        case .diamonds: "suit.diamond.fill"
        case .clubs: "suit.club.fill"
        case .spades: "suit.spade.fill"
        }
    }
}

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

    var strategyKey: String {
        switch self {
        case .ace: "A"
        case .ten, .jack, .queen, .king: "10"
        default: "\(blackjackValue)"
        }
    }
}

struct Card: Equatable, Identifiable {
    let rank: Rank
    let suit: Suit

    var id: String {
        "\(rank.displayValue)\(suit.symbol)"
    }

    var displayValue: String {
        rank.displayValue
    }

    var blackjackValue: Int {
        rank.blackjackValue
    }

    static func random() -> Card {
        Card(rank: Rank.allCases.randomElement()!, suit: Suit.allCases.randomElement()!)
    }
}
