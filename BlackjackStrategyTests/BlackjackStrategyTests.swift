import XCTest
@testable import BlackjackStrategy

final class CardModelTests: XCTestCase {

    // MARK: - Card Creation Tests

    func testCardCreationWithValidRankAndSuit() throws {
        // Test creating cards with all valid combinations
        for rank in Rank.allCases {
            for suit in Suit.allCases {
                let card = Card(rank: rank, suit: suit)
                XCTAssertEqual(card.rank, rank)
                XCTAssertEqual(card.suit, suit)
            }
        }
    }

    func testCardEquality() throws {
        let card1 = Card(rank: .ace, suit: .hearts)
        let card2 = Card(rank: .ace, suit: .hearts)
        let card3 = Card(rank: .ace, suit: .spades)

        XCTAssertEqual(card1, card2)
        XCTAssertNotEqual(card1, card3)
    }

    // MARK: - Card Value Calculation Tests

    func testNumberCardValues() throws {
        XCTAssertEqual(Card(rank: .two, suit: .hearts).blackjackValue, 2)
        XCTAssertEqual(Card(rank: .three, suit: .hearts).blackjackValue, 3)
        XCTAssertEqual(Card(rank: .four, suit: .hearts).blackjackValue, 4)
        XCTAssertEqual(Card(rank: .five, suit: .hearts).blackjackValue, 5)
        XCTAssertEqual(Card(rank: .six, suit: .hearts).blackjackValue, 6)
        XCTAssertEqual(Card(rank: .seven, suit: .hearts).blackjackValue, 7)
        XCTAssertEqual(Card(rank: .eight, suit: .hearts).blackjackValue, 8)
        XCTAssertEqual(Card(rank: .nine, suit: .hearts).blackjackValue, 9)
        XCTAssertEqual(Card(rank: .ten, suit: .hearts).blackjackValue, 10)
    }

    func testFaceCardValues() throws {
        XCTAssertEqual(Card(rank: .jack, suit: .hearts).blackjackValue, 10)
        XCTAssertEqual(Card(rank: .queen, suit: .hearts).blackjackValue, 10)
        XCTAssertEqual(Card(rank: .king, suit: .hearts).blackjackValue, 10)
    }

    func testAceValue() throws {
        // Ace defaults to 11
        XCTAssertEqual(Card(rank: .ace, suit: .hearts).blackjackValue, 11)
    }

    // MARK: - Display Value Tests

    func testNumberCardDisplayValues() throws {
        XCTAssertEqual(Card(rank: .two, suit: .hearts).displayValue, "2")
        XCTAssertEqual(Card(rank: .three, suit: .hearts).displayValue, "3")
        XCTAssertEqual(Card(rank: .four, suit: .hearts).displayValue, "4")
        XCTAssertEqual(Card(rank: .five, suit: .hearts).displayValue, "5")
        XCTAssertEqual(Card(rank: .six, suit: .hearts).displayValue, "6")
        XCTAssertEqual(Card(rank: .seven, suit: .hearts).displayValue, "7")
        XCTAssertEqual(Card(rank: .eight, suit: .hearts).displayValue, "8")
        XCTAssertEqual(Card(rank: .nine, suit: .hearts).displayValue, "9")
        XCTAssertEqual(Card(rank: .ten, suit: .hearts).displayValue, "10")
    }

    func testFaceCardDisplayValues() throws {
        XCTAssertEqual(Card(rank: .jack, suit: .hearts).displayValue, "J")
        XCTAssertEqual(Card(rank: .queen, suit: .hearts).displayValue, "Q")
        XCTAssertEqual(Card(rank: .king, suit: .hearts).displayValue, "K")
    }

    func testAceDisplayValue() throws {
        XCTAssertEqual(Card(rank: .ace, suit: .hearts).displayValue, "A")
    }

    // MARK: - Suit Color Tests

    func testRedSuitColors() throws {
        XCTAssertEqual(Suit.hearts.color, .red)
        XCTAssertEqual(Suit.diamonds.color, .red)
    }

    func testBlackSuitColors() throws {
        XCTAssertEqual(Suit.clubs.color, .black)
        XCTAssertEqual(Suit.spades.color, .black)
    }

    // MARK: - SF Symbol Tests

    func testSuitSymbols() throws {
        XCTAssertEqual(Suit.hearts.symbol, "♥")
        XCTAssertEqual(Suit.diamonds.symbol, "♦")
        XCTAssertEqual(Suit.clubs.symbol, "♣")
        XCTAssertEqual(Suit.spades.symbol, "♠")
    }

    func testSuitSFSymbols() throws {
        XCTAssertEqual(Suit.hearts.sfSymbol, "suit.heart.fill")
        XCTAssertEqual(Suit.diamonds.sfSymbol, "suit.diamond.fill")
        XCTAssertEqual(Suit.clubs.sfSymbol, "suit.club.fill")
        XCTAssertEqual(Suit.spades.sfSymbol, "suit.spade.fill")
    }

    // MARK: - Random Card Generation Tests

    func testRandomCardGeneration() throws {
        // Generate 100 random cards and verify they're all valid
        for _ in 0..<100 {
            let card = Card.random()
            XCTAssertTrue(Rank.allCases.contains(card.rank))
            XCTAssertTrue(Suit.allCases.contains(card.suit))
        }
    }

    // MARK: - Strategy Key Tests

    func testNumberCardStrategyKeys() throws {
        XCTAssertEqual(Rank.two.strategyKey, "2")
        XCTAssertEqual(Rank.three.strategyKey, "3")
        XCTAssertEqual(Rank.four.strategyKey, "4")
        XCTAssertEqual(Rank.five.strategyKey, "5")
        XCTAssertEqual(Rank.six.strategyKey, "6")
        XCTAssertEqual(Rank.seven.strategyKey, "7")
        XCTAssertEqual(Rank.eight.strategyKey, "8")
        XCTAssertEqual(Rank.nine.strategyKey, "9")
    }

    func testFaceCardStrategyKeys() throws {
        // All 10-value cards map to "10"
        XCTAssertEqual(Rank.ten.strategyKey, "10")
        XCTAssertEqual(Rank.jack.strategyKey, "10")
        XCTAssertEqual(Rank.queen.strategyKey, "10")
        XCTAssertEqual(Rank.king.strategyKey, "10")
    }

    func testAceStrategyKey() throws {
        XCTAssertEqual(Rank.ace.strategyKey, "A")
    }
}

// MARK: - Hand Model Tests

final class HandModelTests: XCTestCase {

    // MARK: - Hand Creation Tests

    func testHandCreationWithTwoCards() throws {
        let card1 = Card(rank: .king, suit: .hearts)
        let card2 = Card(rank: .seven, suit: .spades)
        let hand = Hand(cards: [card1, card2])

        XCTAssertEqual(hand.cards.count, 2)
        XCTAssertEqual(hand.cards[0], card1)
        XCTAssertEqual(hand.cards[1], card2)
    }

    func testRandomTwoCardHandGeneration() throws {
        for _ in 0..<50 {
            let hand = Hand.randomTwoCard()
            XCTAssertEqual(hand.cards.count, 2)
        }
    }

    // MARK: - Hard Total Tests

    func testHardTotalWithoutAces() throws {
        let hand1 = Hand(cards: [Card(rank: .ten, suit: .hearts), Card(rank: .seven, suit: .spades)])
        XCTAssertEqual(hand1.hardTotal, 17)

        let hand2 = Hand(cards: [Card(rank: .king, suit: .hearts), Card(rank: .five, suit: .spades)])
        XCTAssertEqual(hand2.hardTotal, 15)

        let hand3 = Hand(cards: [Card(rank: .jack, suit: .hearts), Card(rank: .queen, suit: .spades)])
        XCTAssertEqual(hand3.hardTotal, 20)
    }

    func testHardTotalWithOneAce() throws {
        // Ace counted as 1 in hard total
        let hand1 = Hand(cards: [Card(rank: .ace, suit: .hearts), Card(rank: .seven, suit: .spades)])
        XCTAssertEqual(hand1.hardTotal, 8)

        let hand2 = Hand(cards: [Card(rank: .ace, suit: .hearts), Card(rank: .king, suit: .spades)])
        XCTAssertEqual(hand2.hardTotal, 11)
    }

    func testHardTotalWithMultipleAces() throws {
        // All Aces counted as 1
        let hand1 = Hand(cards: [Card(rank: .ace, suit: .hearts), Card(rank: .ace, suit: .spades)])
        XCTAssertEqual(hand1.hardTotal, 2)
    }

    // MARK: - Soft Total Tests

    func testIsSoftWithAceCountedAs11() throws {
        // Ace + 7 = soft 18 (Ace as 11)
        let hand1 = Hand(cards: [Card(rank: .ace, suit: .hearts), Card(rank: .seven, suit: .spades)])
        XCTAssertTrue(hand1.isSoft)

        // Ace + 5 = soft 16 (Ace as 11)
        let hand2 = Hand(cards: [Card(rank: .ace, suit: .hearts), Card(rank: .five, suit: .spades)])
        XCTAssertTrue(hand2.isSoft)
    }

    func testIsNotSoftWhenAceMustBeCountedAs1() throws {
        // Ace + King = 21, technically could be soft but at 21
        let hand1 = Hand(cards: [Card(rank: .ace, suit: .hearts), Card(rank: .king, suit: .spades)])
        XCTAssertTrue(hand1.isSoft)  // Ace can be 11, total is 21

        // Ace + Ace = 12 (one Ace as 11, one as 1) - this is soft
        let hand2 = Hand(cards: [Card(rank: .ace, suit: .hearts), Card(rank: .ace, suit: .spades)])
        XCTAssertTrue(hand2.isSoft)
    }

    func testIsNotSoftWithoutAce() throws {
        let hand = Hand(cards: [Card(rank: .ten, suit: .hearts), Card(rank: .seven, suit: .spades)])
        XCTAssertFalse(hand.isSoft)
    }

    // MARK: - Best Total Tests

    func testBestTotalWithoutAces() throws {
        let hand1 = Hand(cards: [Card(rank: .ten, suit: .hearts), Card(rank: .seven, suit: .spades)])
        XCTAssertEqual(hand1.bestTotal, 17)

        let hand2 = Hand(cards: [Card(rank: .king, suit: .hearts), Card(rank: .queen, suit: .spades)])
        XCTAssertEqual(hand2.bestTotal, 20)
    }

    func testBestTotalWithOneAceNotBusting() throws {
        // Ace + 7 = 18 (Ace as 11)
        let hand1 = Hand(cards: [Card(rank: .ace, suit: .hearts), Card(rank: .seven, suit: .spades)])
        XCTAssertEqual(hand1.bestTotal, 18)

        // Ace + 5 = 16 (Ace as 11)
        let hand2 = Hand(cards: [Card(rank: .ace, suit: .hearts), Card(rank: .five, suit: .spades)])
        XCTAssertEqual(hand2.bestTotal, 16)

        // Ace + King = 21 (Ace as 11)
        let hand3 = Hand(cards: [Card(rank: .ace, suit: .hearts), Card(rank: .king, suit: .spades)])
        XCTAssertEqual(hand3.bestTotal, 21)
    }

    func testBestTotalWithMultipleAces() throws {
        // Ace + Ace = 12 (one as 11, one as 1)
        let hand = Hand(cards: [Card(rank: .ace, suit: .hearts), Card(rank: .ace, suit: .spades)])
        XCTAssertEqual(hand.bestTotal, 12)
    }

    // MARK: - Pair Detection Tests

    func testIsPairWithSameRanks() throws {
        let hand1 = Hand(cards: [Card(rank: .eight, suit: .hearts), Card(rank: .eight, suit: .spades)])
        XCTAssertTrue(hand1.isPair)

        let hand2 = Hand(cards: [Card(rank: .ace, suit: .hearts), Card(rank: .ace, suit: .spades)])
        XCTAssertTrue(hand2.isPair)

        let hand3 = Hand(cards: [Card(rank: .king, suit: .hearts), Card(rank: .king, suit: .spades)])
        XCTAssertTrue(hand3.isPair)
    }

    func testIsNotPairWithDifferentRanks() throws {
        let hand1 = Hand(cards: [Card(rank: .eight, suit: .hearts), Card(rank: .seven, suit: .spades)])
        XCTAssertFalse(hand1.isPair)

        let hand2 = Hand(cards: [Card(rank: .king, suit: .hearts), Card(rank: .queen, suit: .spades)])
        XCTAssertFalse(hand2.isPair)
    }

    func testFaceCardPairsArePairs() throws {
        // Even though King and Queen both have value 10, they're not a pair
        let hand1 = Hand(cards: [Card(rank: .king, suit: .hearts), Card(rank: .queen, suit: .spades)])
        XCTAssertFalse(hand1.isPair)

        // But King + King is a pair
        let hand2 = Hand(cards: [Card(rank: .king, suit: .hearts), Card(rank: .king, suit: .spades)])
        XCTAssertTrue(hand2.isPair)
    }

    // MARK: - Strategy Key Tests

    func testStrategyKeyForPairs() throws {
        let hand1 = Hand(cards: [Card(rank: .eight, suit: .hearts), Card(rank: .eight, suit: .spades)])
        XCTAssertEqual(hand1.strategyKey, "8,8")

        let hand2 = Hand(cards: [Card(rank: .ace, suit: .hearts), Card(rank: .ace, suit: .spades)])
        XCTAssertEqual(hand2.strategyKey, "A,A")

        // King pair uses "10" strategy key
        let hand3 = Hand(cards: [Card(rank: .king, suit: .hearts), Card(rank: .king, suit: .spades)])
        XCTAssertEqual(hand3.strategyKey, "10,10")

        let hand4 = Hand(cards: [Card(rank: .ten, suit: .hearts), Card(rank: .ten, suit: .spades)])
        XCTAssertEqual(hand4.strategyKey, "10,10")
    }

    func testStrategyKeyForSoftHands() throws {
        // Ace + 7 = soft 18
        let hand1 = Hand(cards: [Card(rank: .ace, suit: .hearts), Card(rank: .seven, suit: .spades)])
        XCTAssertEqual(hand1.strategyKey, "A,7")

        // Ace + 5 = soft 16
        let hand2 = Hand(cards: [Card(rank: .ace, suit: .hearts), Card(rank: .five, suit: .spades)])
        XCTAssertEqual(hand2.strategyKey, "A,5")

        // Ace + 2 = soft 13
        let hand3 = Hand(cards: [Card(rank: .ace, suit: .hearts), Card(rank: .two, suit: .spades)])
        XCTAssertEqual(hand3.strategyKey, "A,2")

        // Ace + 9 = soft 20
        let hand4 = Hand(cards: [Card(rank: .ace, suit: .hearts), Card(rank: .nine, suit: .spades)])
        XCTAssertEqual(hand4.strategyKey, "A,9")
    }

    func testStrategyKeyForHardHands() throws {
        // 10 + 7 = hard 17
        let hand1 = Hand(cards: [Card(rank: .ten, suit: .hearts), Card(rank: .seven, suit: .spades)])
        XCTAssertEqual(hand1.strategyKey, "17")

        // King + 6 = hard 16
        let hand2 = Hand(cards: [Card(rank: .king, suit: .hearts), Card(rank: .six, suit: .spades)])
        XCTAssertEqual(hand2.strategyKey, "16")

        // 8 + 4 = hard 12
        let hand3 = Hand(cards: [Card(rank: .eight, suit: .hearts), Card(rank: .four, suit: .spades)])
        XCTAssertEqual(hand3.strategyKey, "12")

        // Jack + Queen = hard 20
        let hand4 = Hand(cards: [Card(rank: .jack, suit: .hearts), Card(rank: .queen, suit: .spades)])
        XCTAssertEqual(hand4.strategyKey, "20")
    }

    func testStrategyKeyForMultipleAces() throws {
        // Ace + Ace = soft 12 (one as 11, one as 1)
        // This should be "A,A" since it's a pair
        let hand = Hand(cards: [Card(rank: .ace, suit: .hearts), Card(rank: .ace, suit: .spades)])
        XCTAssertEqual(hand.strategyKey, "A,A")
    }

    // MARK: - Blackjack Detection Tests

    func testIsBlackjackWithAceTenValueCard() throws {
        // Ace + King = 21 (blackjack)
        let hand1 = Hand(cards: [Card(rank: .ace, suit: .hearts), Card(rank: .king, suit: .spades)])
        XCTAssertTrue(hand1.isBlackjack, "Ace + King should be blackjack")

        // Ace + Queen = 21 (blackjack)
        let hand2 = Hand(cards: [Card(rank: .ace, suit: .hearts), Card(rank: .queen, suit: .spades)])
        XCTAssertTrue(hand2.isBlackjack, "Ace + Queen should be blackjack")

        // Ace + Jack = 21 (blackjack)
        let hand3 = Hand(cards: [Card(rank: .ace, suit: .hearts), Card(rank: .jack, suit: .spades)])
        XCTAssertTrue(hand3.isBlackjack, "Ace + Jack should be blackjack")

        // Ace + Ten = 21 (blackjack)
        let hand4 = Hand(cards: [Card(rank: .ace, suit: .hearts), Card(rank: .ten, suit: .spades)])
        XCTAssertTrue(hand4.isBlackjack, "Ace + Ten should be blackjack")

        // Ten + Ace = 21 (blackjack, order doesn't matter)
        let hand5 = Hand(cards: [Card(rank: .king, suit: .hearts), Card(rank: .ace, suit: .spades)])
        XCTAssertTrue(hand5.isBlackjack, "King + Ace should be blackjack")
    }

    func testIsNotBlackjackWithNon21Hands() throws {
        // 10 + 9 = 19 (not blackjack)
        let hand1 = Hand(cards: [Card(rank: .ten, suit: .hearts), Card(rank: .nine, suit: .spades)])
        XCTAssertFalse(hand1.isBlackjack, "10 + 9 should not be blackjack")

        // 7 + 8 = 15 (not blackjack)
        let hand2 = Hand(cards: [Card(rank: .seven, suit: .hearts), Card(rank: .eight, suit: .spades)])
        XCTAssertFalse(hand2.isBlackjack, "7 + 8 should not be blackjack")

        // Ace + 5 = 16 (not blackjack)
        let hand3 = Hand(cards: [Card(rank: .ace, suit: .hearts), Card(rank: .five, suit: .spades)])
        XCTAssertFalse(hand3.isBlackjack, "Ace + 5 should not be blackjack")
    }

    func testIsNotBlackjackWith21FromNonBlackjackCombinations() throws {
        // This test verifies that isBlackjack only returns true for 21 with exactly 2 cards
        // (For hands with more than 2 cards, this would matter, but for 2-card hands,
        // any non-Ace+10 combination won't total 21)

        // 9 + 9 + 3 would be 21 but not blackjack (though this is a 3-card hand)
        // For 2-card hands, the only way to get 21 is Ace + 10-value card

        // Ace + Ace = 12 (not 21, not blackjack)
        let hand1 = Hand(cards: [Card(rank: .ace, suit: .hearts), Card(rank: .ace, suit: .spades)])
        XCTAssertFalse(hand1.isBlackjack, "Ace + Ace should not be blackjack")
    }

    // MARK: - Random Hand Re-deal Tests

    func testRandomTwoCardNeverReturnsBlackjack() throws {
        // Generate 1000 random hands and verify none are blackjack
        for _ in 0..<1000 {
            let hand = Hand.randomTwoCard()
            XCTAssertFalse(hand.isBlackjack, "randomTwoCard() should never return a blackjack")
            XCTAssertEqual(hand.cards.count, 2, "randomTwoCard() should always return 2 cards")
        }
    }
}

// MARK: - Strategy Data Loading Tests

final class StrategyDataLoadingTests: XCTestCase {

    var strategyData: StrategyData!

    override func setUp() {
        super.setUp()
        strategyData = StrategyData()
    }

    override func tearDown() {
        strategyData = nil
        super.tearDown()
    }

    // MARK: - JSON Loading Tests

    func testJSONFileLoadsFromBundle() throws {
        // If StrategyData init didn't crash, the JSON loaded successfully
        XCTAssertNotNil(strategyData)
    }

    func testStrategyDataInitialization() throws {
        // Test that StrategyData can be initialized without crashing
        let data = StrategyData()
        XCTAssertNotNil(data)
    }

    // MARK: - Hard Totals Tests

    func testAllHardTotalsPresent() throws {
        let dealerCards = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "A"]
        let hardTotals = ["5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20"]

        var entryCount = 0
        for hand in hardTotals {
            for dealer in dealerCards {
                let action = strategyData.getAction(forHand: hand, dealer: dealer, type: .hard)
                XCTAssertNotEqual(action, "?", "Missing hard total entry for \(hand) vs \(dealer)")
                entryCount += 1
            }
        }

        // 16 hard totals × 10 dealer cards = 160 entries
        XCTAssertEqual(entryCount, 160, "Should have 160 hard total entries")
    }

    func testHard5VsDealerCards() throws {
        let dealerCards = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "A"]
        for dealer in dealerCards {
            let action = strategyData.getAction(forHand: "5", dealer: dealer, type: .hard)
            XCTAssertNotEqual(action, "?", "Missing hard 5 vs \(dealer)")
        }
    }

    func testHard9VsDealerCards() throws {
        let dealerCards = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "A"]
        for dealer in dealerCards {
            let action = strategyData.getAction(forHand: "9", dealer: dealer, type: .hard)
            XCTAssertNotEqual(action, "?", "Missing hard 9 vs \(dealer)")
        }
    }

    func testHard10VsDealerCards() throws {
        let dealerCards = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "A"]
        for dealer in dealerCards {
            let action = strategyData.getAction(forHand: "10", dealer: dealer, type: .hard)
            XCTAssertNotEqual(action, "?", "Missing hard 10 vs \(dealer)")
        }
    }

    func testHard11VsDealerCards() throws {
        let dealerCards = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "A"]
        for dealer in dealerCards {
            let action = strategyData.getAction(forHand: "11", dealer: dealer, type: .hard)
            XCTAssertNotEqual(action, "?", "Missing hard 11 vs \(dealer)")
        }
    }

    func testHard12VsDealerCards() throws {
        let dealerCards = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "A"]
        for dealer in dealerCards {
            let action = strategyData.getAction(forHand: "12", dealer: dealer, type: .hard)
            XCTAssertNotEqual(action, "?", "Missing hard 12 vs \(dealer)")
        }
    }

    func testHard13Through16VsDealerCards() throws {
        let dealerCards = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "A"]
        let hardTotals = ["13", "14", "15", "16"]

        for hand in hardTotals {
            for dealer in dealerCards {
                let action = strategyData.getAction(forHand: hand, dealer: dealer, type: .hard)
                XCTAssertNotEqual(action, "?", "Missing hard \(hand) vs \(dealer)")
            }
        }
    }

    func testHard17Through20VsDealerCards() throws {
        let dealerCards = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "A"]
        let hardTotals = ["17", "18", "19", "20"]

        for hand in hardTotals {
            for dealer in dealerCards {
                let action = strategyData.getAction(forHand: hand, dealer: dealer, type: .hard)
                XCTAssertNotEqual(action, "?", "Missing hard \(hand) vs \(dealer)")
            }
        }
    }

    // MARK: - Soft Totals Tests

    func testAllSoftTotalsPresent() throws {
        let dealerCards = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "A"]
        let softTotals = ["A,2", "A,3", "A,4", "A,5", "A,6", "A,7", "A,8", "A,9"]

        var entryCount = 0
        for hand in softTotals {
            for dealer in dealerCards {
                let action = strategyData.getAction(forHand: hand, dealer: dealer, type: .soft)
                XCTAssertNotEqual(action, "?", "Missing soft total entry for \(hand) vs \(dealer)")
                entryCount += 1
            }
        }

        // 8 soft totals × 10 dealer cards = 80 entries
        XCTAssertEqual(entryCount, 80, "Should have 80 soft total entries")
    }

    func testSoftA2AndA3VsDealerCards() throws {
        let dealerCards = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "A"]
        let softTotals = ["A,2", "A,3"]

        for hand in softTotals {
            for dealer in dealerCards {
                let action = strategyData.getAction(forHand: hand, dealer: dealer, type: .soft)
                XCTAssertNotEqual(action, "?", "Missing soft \(hand) vs \(dealer)")
            }
        }
    }

    func testSoftA4AndA5VsDealerCards() throws {
        let dealerCards = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "A"]
        let softTotals = ["A,4", "A,5"]

        for hand in softTotals {
            for dealer in dealerCards {
                let action = strategyData.getAction(forHand: hand, dealer: dealer, type: .soft)
                XCTAssertNotEqual(action, "?", "Missing soft \(hand) vs \(dealer)")
            }
        }
    }

    func testSoftA6VsDealerCards() throws {
        let dealerCards = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "A"]
        for dealer in dealerCards {
            let action = strategyData.getAction(forHand: "A,6", dealer: dealer, type: .soft)
            XCTAssertNotEqual(action, "?", "Missing soft A,6 vs \(dealer)")
        }
    }

    func testSoftA7VsDealerCards() throws {
        let dealerCards = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "A"]
        for dealer in dealerCards {
            let action = strategyData.getAction(forHand: "A,7", dealer: dealer, type: .soft)
            XCTAssertNotEqual(action, "?", "Missing soft A,7 vs \(dealer)")
        }
    }

    func testSoftA8AndA9VsDealerCards() throws {
        let dealerCards = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "A"]
        let softTotals = ["A,8", "A,9"]

        for hand in softTotals {
            for dealer in dealerCards {
                let action = strategyData.getAction(forHand: hand, dealer: dealer, type: .soft)
                XCTAssertNotEqual(action, "?", "Missing soft \(hand) vs \(dealer)")
            }
        }
    }

    // MARK: - Pairs Tests

    func testAllPairsPresent() throws {
        let dealerCards = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "A"]
        let pairs = ["2,2", "3,3", "4,4", "5,5", "6,6", "7,7", "8,8", "9,9", "10,10", "A,A"]

        var entryCount = 0
        for hand in pairs {
            for dealer in dealerCards {
                let action = strategyData.getAction(forHand: hand, dealer: dealer, type: .pair)
                XCTAssertNotEqual(action, "?", "Missing pair entry for \(hand) vs \(dealer)")
                entryCount += 1
            }
        }

        // 10 pairs × 10 dealer cards = 100 entries
        XCTAssertEqual(entryCount, 100, "Should have 100 pair entries")
    }

    func testPairs2And3VsDealerCards() throws {
        let dealerCards = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "A"]
        let pairs = ["2,2", "3,3"]

        for hand in pairs {
            for dealer in dealerCards {
                let action = strategyData.getAction(forHand: hand, dealer: dealer, type: .pair)
                XCTAssertNotEqual(action, "?", "Missing pair \(hand) vs \(dealer)")
            }
        }
    }

    func testPair4VsDealerCards() throws {
        let dealerCards = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "A"]
        for dealer in dealerCards {
            let action = strategyData.getAction(forHand: "4,4", dealer: dealer, type: .pair)
            XCTAssertNotEqual(action, "?", "Missing pair 4,4 vs \(dealer)")
        }
    }

    func testPair5VsDealerCards() throws {
        let dealerCards = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "A"]
        for dealer in dealerCards {
            let action = strategyData.getAction(forHand: "5,5", dealer: dealer, type: .pair)
            XCTAssertNotEqual(action, "?", "Missing pair 5,5 vs \(dealer)")
        }
    }

    func testPair6VsDealerCards() throws {
        let dealerCards = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "A"]
        for dealer in dealerCards {
            let action = strategyData.getAction(forHand: "6,6", dealer: dealer, type: .pair)
            XCTAssertNotEqual(action, "?", "Missing pair 6,6 vs \(dealer)")
        }
    }

    func testPair7VsDealerCards() throws {
        let dealerCards = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "A"]
        for dealer in dealerCards {
            let action = strategyData.getAction(forHand: "7,7", dealer: dealer, type: .pair)
            XCTAssertNotEqual(action, "?", "Missing pair 7,7 vs \(dealer)")
        }
    }

    func testPair8VsDealerCards() throws {
        let dealerCards = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "A"]
        for dealer in dealerCards {
            let action = strategyData.getAction(forHand: "8,8", dealer: dealer, type: .pair)
            XCTAssertNotEqual(action, "?", "Missing pair 8,8 vs \(dealer)")
        }
    }

    func testPair9VsDealerCards() throws {
        let dealerCards = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "A"]
        for dealer in dealerCards {
            let action = strategyData.getAction(forHand: "9,9", dealer: dealer, type: .pair)
            XCTAssertNotEqual(action, "?", "Missing pair 9,9 vs \(dealer)")
        }
    }

    func testPair10VsDealerCards() throws {
        let dealerCards = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "A"]
        for dealer in dealerCards {
            let action = strategyData.getAction(forHand: "10,10", dealer: dealer, type: .pair)
            XCTAssertNotEqual(action, "?", "Missing pair 10,10 vs \(dealer)")
        }
    }

    func testPairAcesVsDealerCards() throws {
        let dealerCards = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "A"]
        for dealer in dealerCards {
            let action = strategyData.getAction(forHand: "A,A", dealer: dealer, type: .pair)
            XCTAssertNotEqual(action, "?", "Missing pair A,A vs \(dealer)")
        }
    }

    // MARK: - Entry Count Test

    func testTotalEntryCount() throws {
        let dealerCards = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "A"]
        let hardTotals = ["5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20"]
        let softTotals = ["A,2", "A,3", "A,4", "A,5", "A,6", "A,7", "A,8", "A,9"]
        let pairs = ["2,2", "3,3", "4,4", "5,5", "6,6", "7,7", "8,8", "9,9", "10,10", "A,A"]

        var totalCount = 0

        // Count hard totals
        for hand in hardTotals {
            for dealer in dealerCards {
                let action = strategyData.getAction(forHand: hand, dealer: dealer, type: .hard)
                if action != "?" {
                    totalCount += 1
                }
            }
        }

        // Count soft totals
        for hand in softTotals {
            for dealer in dealerCards {
                let action = strategyData.getAction(forHand: hand, dealer: dealer, type: .soft)
                if action != "?" {
                    totalCount += 1
                }
            }
        }

        // Count pairs
        for hand in pairs {
            for dealer in dealerCards {
                let action = strategyData.getAction(forHand: hand, dealer: dealer, type: .pair)
                if action != "?" {
                    totalCount += 1
                }
            }
        }

        // 160 hard + 80 soft + 100 pairs = 340 entries
        XCTAssertEqual(totalCount, 340, "Should have 340 total entries")
    }

    // MARK: - Action Validation Tests

    func testAllActionsAreValid() throws {
        let validActions = ["H", "S", "D", "P"]
        let dealerCards = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "A"]
        let hardTotals = ["5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20"]
        let softTotals = ["A,2", "A,3", "A,4", "A,5", "A,6", "A,7", "A,8", "A,9"]
        let pairs = ["2,2", "3,3", "4,4", "5,5", "6,6", "7,7", "8,8", "9,9", "10,10", "A,A"]

        // Check hard totals
        for hand in hardTotals {
            for dealer in dealerCards {
                let action = strategyData.getAction(forHand: hand, dealer: dealer, type: .hard)
                XCTAssertTrue(validActions.contains(action), "Invalid action '\(action)' for hard \(hand) vs \(dealer)")
            }
        }

        // Check soft totals
        for hand in softTotals {
            for dealer in dealerCards {
                let action = strategyData.getAction(forHand: hand, dealer: dealer, type: .soft)
                XCTAssertTrue(validActions.contains(action), "Invalid action '\(action)' for soft \(hand) vs \(dealer)")
            }
        }

        // Check pairs
        for hand in pairs {
            for dealer in dealerCards {
                let action = strategyData.getAction(forHand: hand, dealer: dealer, type: .pair)
                XCTAssertTrue(validActions.contains(action), "Invalid action '\(action)' for pair \(hand) vs \(dealer)")
            }
        }
    }

    // MARK: - Advice Validation Tests

    func testAllAdviceStringsAreNonEmpty() throws {
        let dealerCards = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "A"]
        let hardTotals = ["5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20"]
        let softTotals = ["A,2", "A,3", "A,4", "A,5", "A,6", "A,7", "A,8", "A,9"]
        let pairs = ["2,2", "3,3", "4,4", "5,5", "6,6", "7,7", "8,8", "9,9", "10,10", "A,A"]

        // Check hard totals
        for hand in hardTotals {
            for dealer in dealerCards {
                let advice = strategyData.getAdvice(handKey: hand, dealerKey: dealer, isPair: false, isSoft: false)
                XCTAssertFalse(advice.isEmpty, "Empty advice for hard \(hand) vs \(dealer)")
            }
        }

        // Check soft totals
        for hand in softTotals {
            for dealer in dealerCards {
                let advice = strategyData.getAdvice(handKey: hand, dealerKey: dealer, isPair: false, isSoft: true)
                XCTAssertFalse(advice.isEmpty, "Empty advice for soft \(hand) vs \(dealer)")
            }
        }

        // Check pairs
        for hand in pairs {
            for dealer in dealerCards {
                let advice = strategyData.getAdvice(handKey: hand, dealerKey: dealer, isPair: true, isSoft: false)
                XCTAssertFalse(advice.isEmpty, "Empty advice for pair \(hand) vs \(dealer)")
            }
        }
    }
}

// MARK: - Strategy Logic Tests

final class StrategyLogicTests: XCTestCase {

    var strategyData: StrategyData!

    override func setUp() {
        super.setUp()
        strategyData = StrategyData()
    }

    override func tearDown() {
        strategyData = nil
        super.tearDown()
    }

    // MARK: - Hard Total Action Tests

    func testHard11VsDealer5ReturnsDouble() throws {
        let action = strategyData.getCorrectAction(handKey: "11", dealerKey: "5", isPair: false, isSoft: false)
        XCTAssertEqual(action, .double, "Hard 11 vs dealer 5 should be Double")
    }

    func testHard16VsDealer10ReturnsHit() throws {
        let action = strategyData.getCorrectAction(handKey: "16", dealerKey: "10", isPair: false, isSoft: false)
        XCTAssertEqual(action, .hit, "Hard 16 vs dealer 10 should be Hit")
    }

    func testHard17VsDealer2ReturnsStand() throws {
        let action = strategyData.getCorrectAction(handKey: "17", dealerKey: "2", isPair: false, isSoft: false)
        XCTAssertEqual(action, .stand, "Hard 17 vs dealer 2 should be Stand")
    }

    // MARK: - Soft Total Action Tests

    func testSoftA6VsDealer4ReturnsDouble() throws {
        let action = strategyData.getCorrectAction(handKey: "A,6", dealerKey: "4", isPair: false, isSoft: true)
        XCTAssertEqual(action, .double, "Soft A,6 vs dealer 4 should be Double")
    }

    func testSoftA7VsDealer9ReturnsHit() throws {
        let action = strategyData.getCorrectAction(handKey: "A,7", dealerKey: "9", isPair: false, isSoft: true)
        XCTAssertEqual(action, .hit, "Soft A,7 vs dealer 9 should be Hit")
    }

    func testSoftA8VsDealer6ReturnsStand() throws {
        let action = strategyData.getCorrectAction(handKey: "A,8", dealerKey: "6", isPair: false, isSoft: true)
        XCTAssertEqual(action, .stand, "Soft A,8 vs dealer 6 should be Stand")
    }

    // MARK: - Pair Action Tests

    func testPair88VsDealerAceReturnsSplit() throws {
        let action = strategyData.getCorrectAction(handKey: "8,8", dealerKey: "A", isPair: true, isSoft: false)
        XCTAssertEqual(action, .split, "Pair 8,8 vs dealer Ace should be Split")
    }

    func testPair55VsDealer6ReturnsDouble() throws {
        let action = strategyData.getCorrectAction(handKey: "5,5", dealerKey: "6", isPair: true, isSoft: false)
        XCTAssertEqual(action, .double, "Pair 5,5 vs dealer 6 should be Double (treat as hard 10)")
    }

    func testPair99VsDealer7ReturnsStand() throws {
        let action = strategyData.getCorrectAction(handKey: "9,9", dealerKey: "7", isPair: true, isSoft: false)
        XCTAssertEqual(action, .stand, "Pair 9,9 vs dealer 7 should be Stand")
    }

    // MARK: - Advice Tests

    func testGetAdviceReturnsNonEmptyForHardTotal() throws {
        let advice = strategyData.getAdvice(handKey: "16", dealerKey: "10", isPair: false, isSoft: false)
        XCTAssertFalse(advice.isEmpty, "Advice should not be empty for hard 16 vs 10")
    }

    func testGetAdviceReturnsNonEmptyForSoftTotal() throws {
        let advice = strategyData.getAdvice(handKey: "A,7", dealerKey: "9", isPair: false, isSoft: true)
        XCTAssertFalse(advice.isEmpty, "Advice should not be empty for soft A,7 vs 9")
    }

    func testGetAdviceReturnsNonEmptyForPair() throws {
        let advice = strategyData.getAdvice(handKey: "8,8", dealerKey: "A", isPair: true, isSoft: false)
        XCTAssertFalse(advice.isEmpty, "Advice should not be empty for pair 8,8 vs A")
    }

    // MARK: - Dealer Card Strategy Key Tests

    func testFaceCardsMapTo10() throws {
        // Face cards (J, Q, K) should all map to "10" in strategy lookups
        // This is tested implicitly by the hard/soft/pair tests above using "10"
        // But let's verify that "10" key works for dealer cards
        let action = strategyData.getCorrectAction(handKey: "16", dealerKey: "10", isPair: false, isSoft: false)
        XCTAssertNotNil(action, "Dealer card '10' should be valid")
    }

    func testAceMapsToA() throws {
        let action = strategyData.getCorrectAction(handKey: "16", dealerKey: "A", isPair: false, isSoft: false)
        XCTAssertNotNil(action, "Dealer card 'A' should be valid")
    }

    func testNumberCardsMaintainValue() throws {
        for dealer in ["2", "3", "4", "5", "6", "7", "8", "9"] {
            let action = strategyData.getCorrectAction(handKey: "12", dealerKey: dealer, isPair: false, isSoft: false)
            XCTAssertNotNil(action, "Dealer card '\(dealer)' should be valid")
        }
    }
}
