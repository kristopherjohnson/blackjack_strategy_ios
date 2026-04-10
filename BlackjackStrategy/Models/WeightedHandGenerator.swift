import Foundation

/// Modes for practice hand generation.
enum PracticeMode: String, CaseIterable {
    case random = "Random"
    case weighted = "Weighted"
}

/// Generates hands biased toward strategy keys the player gets wrong most often.
struct WeightedHandGenerator {
    /// Minimum total plays before weighted mode activates.
    static let globalPlayThreshold = 20

    /// Minimum plays for a single hand key before its accuracy influences weight.
    static let perHandPlayThreshold = 10

    /// A two-card rank combination. Suits are randomized at generation time.
    struct RankCombo {
        let rank1: Rank
        let rank2: Rank
    }

    /// Entry mapping a strategy key to all valid two-card rank combos that produce it.
    struct ComboEntry {
        let category: HandCategory
        let key: String
        let combos: [RankCombo]
    }

    /// Precomputed mapping from strategy keys to valid two-card combinations.
    let comboTable: [ComboEntry]

    /// Builds the combo table by enumerating all two-card rank pairs.
    init() {
        var table: [String: (category: HandCategory, combos: [RankCombo])] = [:]

        let allRanks = Rank.allCases
        for r1 in allRanks {
            for r2 in allRanks where r2.rawValue >= r1.rawValue {
                // Build a temporary hand to classify it
                let card1 = Card(rank: r1, suit: .spades)
                let card2 = Card(rank: r2, suit: .hearts)
                let hand = Hand(cards: [card1, card2])

                // Skip blackjacks
                if hand.isBlackjack { continue }

                let key = hand.strategyKey
                let category: HandCategory
                if hand.isPair {
                    category = .pairs
                } else if hand.isSoft {
                    category = .soft
                } else {
                    category = .hard
                }

                // Use category+key as the lookup to handle "10" appearing in both hard and pairs
                let tableKey = "\(category.rawValue):\(key)"
                if table[tableKey] == nil {
                    table[tableKey] = (category: category, combos: [])
                }
                table[tableKey]!.combos.append(RankCombo(rank1: r1, rank2: r2))
            }
        }

        comboTable = table.map { (tableKey, value) in
            let key = String(tableKey.split(separator: ":").last!)
            return ComboEntry(category: value.category, key: key, combos: value.combos)
        }
    }

    /// Generates a hand using weighted random sampling based on player accuracy.
    ///
    /// Falls back to uniform-random generation if insufficient data exists.
    func generateHand(using stats: StatisticsStore) -> (hand: Hand, dealerCard: Card) {
        // Check global threshold
        guard let overall = stats.overallAccuracy,
              overall.plays >= Self.globalPlayThreshold else {
            return (Hand.randomTwoCard(), Card.random())
        }

        // Compute weights for each strategy key
        let weights = computeWeights(using: stats)
        let totalWeight = weights.reduce(0.0) { $0 + $1.weight }

        // Weighted random selection
        let roll = Double.random(in: 0..<totalWeight)
        var cumulative = 0.0
        var selectedIndex = 0
        for (index, entry) in weights.enumerated() {
            cumulative += entry.weight
            if roll < cumulative {
                selectedIndex = index
                break
            }
        }

        let selected = weights[selectedIndex]

        // Find the combo entry for this key
        guard let comboEntry = comboTable.first(where: {
            $0.category == selected.category && $0.key == selected.key
        }), !comboEntry.combos.isEmpty else {
            return (Hand.randomTwoCard(), Card.random())
        }

        // Pick a random combo and assign random suits
        let combo = comboEntry.combos.randomElement()!
        let suit1 = Suit.allCases.randomElement()!
        let suit2 = Suit.allCases.randomElement()!

        // Randomly swap card order so the hand doesn't always show lower rank first
        let cards: [Card]
        if Bool.random() {
            cards = [Card(rank: combo.rank1, suit: suit1), Card(rank: combo.rank2, suit: suit2)]
        } else {
            cards = [Card(rank: combo.rank2, suit: suit2), Card(rank: combo.rank1, suit: suit1)]
        }

        return (Hand(cards: cards), Card.random())
    }

    /// Computes a weight for each strategy key based on accuracy data.
    ///
    /// Lower accuracy → higher weight. Hands with insufficient data get neutral weight.
    func computeWeights(using stats: StatisticsStore) -> [(category: HandCategory, key: String, weight: Double)] {
        comboTable.map { entry in
            let accuracy = stats.handAccuracy(category: entry.category, key: entry.key)
            let weight: Double
            if let accuracy, accuracy.plays >= Self.perHandPlayThreshold {
                let rate = Double(accuracy.correct) / Double(accuracy.plays)
                weight = max(0.2, 1.0 - rate) + 0.1
            } else {
                weight = 1.0
            }
            return (category: entry.category, key: entry.key, weight: weight)
        }
    }
}
