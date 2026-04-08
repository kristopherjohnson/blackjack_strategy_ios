import XCTest
@testable import BlackjackStrategy

final class WeightedHandGeneratorTests: XCTestCase {
    private let generator = WeightedHandGenerator()

    private func makeStore() -> StatisticsStore {
        let defaults = UserDefaults(suiteName: "TestWeighted")!
        defaults.removePersistentDomain(forName: "TestWeighted")
        return StatisticsStore(defaults: defaults)
    }

    // MARK: - Combo Table Tests

    func testComboTableCoversAllStrategyKeys() {
        // All 34 strategy keys should have at least one combo
        let hardKeys = Set(["5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20"])
        let softKeys = Set(["A,2", "A,3", "A,4", "A,5", "A,6", "A,7", "A,8", "A,9"])
        let pairKeys = Set(["2,2", "3,3", "4,4", "5,5", "6,6", "7,7", "8,8", "9,9", "10,10", "A,A"])

        let hardEntries = Set(generator.comboTable.filter { $0.category == .hard }.map { $0.key })
        let softEntries = Set(generator.comboTable.filter { $0.category == .soft }.map { $0.key })
        let pairEntries = Set(generator.comboTable.filter { $0.category == .pairs }.map { $0.key })

        XCTAssertEqual(hardEntries, hardKeys, "Missing hard total keys")
        XCTAssertEqual(softEntries, softKeys, "Missing soft total keys")
        XCTAssertEqual(pairEntries, pairKeys, "Missing pair keys")
    }

    func testComboTableHas34Entries() {
        XCTAssertEqual(generator.comboTable.count, 34)
    }

    func testNoCombosProduceBlackjack() {
        for entry in generator.comboTable {
            for combo in entry.combos {
                let hand = Hand(cards: [
                    Card(rank: combo.rank1, suit: .spades),
                    Card(rank: combo.rank2, suit: .hearts)
                ])
                XCTAssertFalse(hand.isBlackjack,
                    "Combo \(combo.rank1) + \(combo.rank2) for key \(entry.key) is blackjack")
            }
        }
    }

    func testCombosMatchTheirStrategyKey() {
        for entry in generator.comboTable {
            for combo in entry.combos {
                let hand = Hand(cards: [
                    Card(rank: combo.rank1, suit: .spades),
                    Card(rank: combo.rank2, suit: .hearts)
                ])
                XCTAssertEqual(hand.strategyKey, entry.key,
                    "Combo \(combo.rank1) + \(combo.rank2) has key \(hand.strategyKey), expected \(entry.key)")
            }
        }
    }

    func testFaceCardPairsIncludeMultipleCombos() {
        // "10,10" includes only same-rank pairs: (ten,ten), (J,J), (Q,Q), (K,K)
        // Cross-rank combos like (ten,jack) are classified as hard 20, not pairs
        let tenPair = generator.comboTable.first { $0.category == .pairs && $0.key == "10,10" }
        XCTAssertNotNil(tenPair)
        XCTAssertEqual(tenPair!.combos.count, 4,
            "10,10 pair should have 4 combos (one per 10-value rank)")
    }

    // MARK: - Weight Computation Tests

    func testWeightsAllNeutralWithNoData() {
        let store = makeStore()
        let weights = generator.computeWeights(using: store)
        for entry in weights {
            XCTAssertEqual(entry.weight, 1.0,
                "Weight for \(entry.key) should be 1.0 with no data")
        }
    }

    func testLowAccuracyGetsHighWeight() {
        let store = makeStore()
        // Record 10 plays for hard 16, all wrong
        for _ in 0..<10 {
            store.record(PlayResult(handCategory: .hard, handKey: "16", isCorrect: false))
        }
        let weights = generator.computeWeights(using: store)
        let hard16 = weights.first { $0.category == .hard && $0.key == "16" }
        XCTAssertNotNil(hard16)
        // 0% accuracy → max(0.2, 1.0 - 0.0) + 0.1 = 1.1
        XCTAssertEqual(hard16!.weight, 1.1, accuracy: 0.01)
    }

    func testHighAccuracyGetsLowWeight() {
        let store = makeStore()
        // Record 10 plays for hard 20, all correct
        for _ in 0..<10 {
            store.record(PlayResult(handCategory: .hard, handKey: "20", isCorrect: true))
        }
        let weights = generator.computeWeights(using: store)
        let hard20 = weights.first { $0.category == .hard && $0.key == "20" }
        XCTAssertNotNil(hard20)
        // 100% accuracy → max(0.2, 1.0 - 1.0) + 0.1 = 0.3
        XCTAssertEqual(hard20!.weight, 0.3, accuracy: 0.01)
    }

    func testBelowPerHandThresholdGetsNeutralWeight() {
        let store = makeStore()
        // Record only 5 plays (below threshold of 10)
        for _ in 0..<5 {
            store.record(PlayResult(handCategory: .hard, handKey: "16", isCorrect: false))
        }
        let weights = generator.computeWeights(using: store)
        let hard16 = weights.first { $0.category == .hard && $0.key == "16" }
        XCTAssertNotNil(hard16)
        XCTAssertEqual(hard16!.weight, 1.0, "Below per-hand threshold should be neutral")
    }

    // MARK: - Hand Generation Tests

    func testGenerateHandFallsBackWithInsufficientData() {
        let store = makeStore()
        // Only 5 plays — below global threshold of 20
        for _ in 0..<5 {
            store.record(PlayResult(handCategory: .hard, handKey: "16", isCorrect: false))
        }
        // Should not crash, returns a valid hand
        let result = generator.generateHand(using: store)
        XCTAssertEqual(result.hand.cards.count, 2)
        XCTAssertFalse(result.hand.isBlackjack)
    }

    func testGenerateHandProducesValidHands() {
        let store = makeStore()
        // Record enough data to activate weighted mode
        for _ in 0..<25 {
            store.record(PlayResult(handCategory: .hard, handKey: "16", isCorrect: false))
        }
        // Generate many hands and verify all are valid
        for _ in 0..<100 {
            let result = generator.generateHand(using: store)
            XCTAssertEqual(result.hand.cards.count, 2)
            XCTAssertFalse(result.hand.isBlackjack)
        }
    }

    func testGenerateHandStrategyKeyMatchesComboTable() {
        let store = makeStore()
        // Record enough data
        for _ in 0..<25 {
            store.record(PlayResult(handCategory: .hard, handKey: "16", isCorrect: false))
        }
        // All generated hands should have a strategy key present in the combo table
        let allKeys = Set(generator.comboTable.map { "\($0.category.rawValue):\($0.key)" })
        for _ in 0..<100 {
            let result = generator.generateHand(using: store)
            let hand = result.hand
            let category: HandCategory
            if hand.isPair {
                category = .pairs
            } else if hand.isSoft {
                category = .soft
            } else {
                category = .hard
            }
            let lookupKey = "\(category.rawValue):\(hand.strategyKey)"
            XCTAssertTrue(allKeys.contains(lookupKey),
                "Generated hand key \(lookupKey) not in combo table")
        }
    }

    func testDealerCardIsIndependent() {
        let store = makeStore()
        for _ in 0..<25 {
            store.record(PlayResult(handCategory: .hard, handKey: "16", isCorrect: false))
        }
        // Generate many dealer cards and verify we see variety (not all the same)
        var dealerRanks = Set<Rank>()
        for _ in 0..<50 {
            let result = generator.generateHand(using: store)
            dealerRanks.insert(result.dealerCard.rank)
        }
        XCTAssertTrue(dealerRanks.count > 1, "Dealer cards should have variety")
    }
}
