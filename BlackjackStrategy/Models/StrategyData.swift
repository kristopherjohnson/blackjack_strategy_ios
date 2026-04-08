import Foundation

/// A single entry in the strategy table: the recommended action and explanatory advice.
struct StrategyEntry: Codable {
    /// The recommended action code: "H" (hit), "S" (stand), "D" (double), or "P" (split).
    let action: String

    /// Mnemonic or explanation for why this is the correct play.
    let advice: String
}

/// Top-level JSON structure for the strategy data file, organized by hand type.
struct StrategyJSON: Codable {
    /// Hard total strategies keyed by player total then dealer card.
    let hard: [String: [String: StrategyEntry]]

    /// Soft total strategies keyed by player hand (e.g. "A,6") then dealer card.
    let soft: [String: [String: StrategyEntry]]

    /// Pair strategies keyed by pair value (e.g. "8,8") then dealer card.
    let pairs: [String: [String: StrategyEntry]]
}

/// Loads and provides lookups into the basic strategy table from `strategy.json`.
class StrategyData {
    /// Classification of a blackjack hand for strategy lookup.
    enum HandType: Hashable {
        case hard, soft, pair
    }

    /// The decoded strategy data.
    private let data: StrategyJSON

    /// All hard total row keys in display order ("5" through "20").
    let hardTotals = ["5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20"]

    /// All soft total row keys in display order ("A,2" through "A,9").
    let softTotals = ["A,2", "A,3", "A,4", "A,5", "A,6", "A,7", "A,8", "A,9"]

    /// All pair row keys in display order ("2,2" through "A,A").
    let pairTotals = ["2,2", "3,3", "4,4", "5,5", "6,6", "7,7", "8,8", "9,9", "10,10", "A,A"]

    /// Dealer up-card column keys ("2" through "A").
    let dealerCards = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "A"]

    /// Loads strategy data from the bundled `strategy.json` file. Fatal error if missing or malformed.
    init() {
        guard let url = Bundle.main.url(forResource: "strategy", withExtension: "json"),
              let jsonData = try? Data(contentsOf: url),
              let decoded = try? JSONDecoder().decode(StrategyJSON.self, from: jsonData)
        else {
            fatalError("Failed to load strategy.json")
        }
        data = decoded
    }

    /// Returns the correct player action for the given hand and dealer card.
    func getCorrectAction(handKey: String, dealerKey: String, isPair: Bool, isSoft: Bool) -> PlayerAction {
        let type = handType(isPair: isPair, isSoft: isSoft)
        let actionStr = getEntry(hand: handKey, dealer: dealerKey, type: type)?.action ?? "S"
        return PlayerAction(rawValue: actionStr) ?? .stand
    }

    /// Returns the advice/mnemonic string for the given hand and dealer card.
    func getAdvice(handKey: String, dealerKey: String, isPair: Bool, isSoft: Bool) -> String {
        let type = handType(isPair: isPair, isSoft: isSoft)
        return getEntry(hand: handKey, dealer: dealerKey, type: type)?.advice ?? "Follow basic strategy."
    }

    /// Returns the raw action string (e.g. "H", "S") for a hand/dealer/type combination.
    func getAction(forHand hand: String, dealer: String, type: HandType) -> String {
        getEntry(hand: hand, dealer: dealer, type: type)?.action ?? "?"
    }

    /// Determines the hand type from pair/soft flags.
    private func handType(isPair: Bool, isSoft: Bool) -> HandType {
        if isPair { return .pair }
        if isSoft { return .soft }
        return .hard
    }

    /// Looks up a strategy entry by hand key, dealer key, and hand type.
    private func getEntry(hand: String, dealer: String, type: HandType) -> StrategyEntry? {
        switch type {
        case .hard: data.hard[hand]?[dealer]
        case .soft: data.soft[hand]?[dealer]
        case .pair: data.pairs[hand]?[dealer]
        }
    }
}
