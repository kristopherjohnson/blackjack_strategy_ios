import Foundation

struct StrategyEntry: Codable {
    let action: String
    let advice: String
}

struct StrategyJSON: Codable {
    let hard: [String: [String: StrategyEntry]]
    let soft: [String: [String: StrategyEntry]]
    let pairs: [String: [String: StrategyEntry]]
}

class StrategyData {
    enum HandType: Hashable {
        case hard, soft, pair
    }

    private let data: StrategyJSON

    let hardTotals = ["5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20"]
    let softTotals = ["A,2", "A,3", "A,4", "A,5", "A,6", "A,7", "A,8", "A,9"]
    let pairTotals = ["2,2", "3,3", "4,4", "5,5", "6,6", "7,7", "8,8", "9,9", "10,10", "A,A"]
    let dealerCards = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "A"]

    init() {
        guard let url = Bundle.main.url(forResource: "strategy", withExtension: "json"),
              let jsonData = try? Data(contentsOf: url),
              let decoded = try? JSONDecoder().decode(StrategyJSON.self, from: jsonData)
        else {
            fatalError("Failed to load strategy.json")
        }
        data = decoded
    }

    func getCorrectAction(handKey: String, dealerKey: String, isPair: Bool, isSoft: Bool) -> PlayerAction {
        let type = handType(isPair: isPair, isSoft: isSoft)
        let actionStr = getEntry(hand: handKey, dealer: dealerKey, type: type)?.action ?? "S"
        return PlayerAction(rawValue: actionStr) ?? .stand
    }

    func getAdvice(handKey: String, dealerKey: String, isPair: Bool, isSoft: Bool) -> String {
        let type = handType(isPair: isPair, isSoft: isSoft)
        return getEntry(hand: handKey, dealer: dealerKey, type: type)?.advice ?? "Follow basic strategy."
    }

    func getAction(forHand hand: String, dealer: String, type: HandType) -> String {
        getEntry(hand: hand, dealer: dealer, type: type)?.action ?? "?"
    }

    private func handType(isPair: Bool, isSoft: Bool) -> HandType {
        if isPair { return .pair }
        if isSoft { return .soft }
        return .hard
    }

    private func getEntry(hand: String, dealer: String, type: HandType) -> StrategyEntry? {
        switch type {
        case .hard: data.hard[hand]?[dealer]
        case .soft: data.soft[hand]?[dealer]
        case .pair: data.pairs[hand]?[dealer]
        }
    }
}
