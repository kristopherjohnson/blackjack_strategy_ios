import XCTest
@testable import BlackjackStrategy

final class StatisticsStoreTests: XCTestCase {
    // Use a dedicated suite to avoid polluting app UserDefaults
    private func makeStore() -> StatisticsStore {
        let defaults = UserDefaults(suiteName: "TestStatistics")!
        defaults.removePersistentDomain(forName: "TestStatistics")
        return StatisticsStore(defaults: defaults)
    }

    func testRecordAddsEntry() {
        let store = makeStore()
        store.record(PlayResult(handCategory: .hard, handKey: "16", isCorrect: true))
        XCTAssertEqual(store.overallAccuracy?.plays, 1)
    }

    func testBufferCapsAt1000() {
        let store = makeStore()
        for _ in 0..<1001 {
            store.record(PlayResult(handCategory: .hard, handKey: "16", isCorrect: true))
        }
        XCTAssertEqual(store.overallAccuracy?.plays, 1000)
    }

    func testOldestDropped() {
        let store = makeStore()
        // Record 1 wrong play first, then 1000 correct plays
        store.record(PlayResult(handCategory: .hard, handKey: "16", isCorrect: false))
        for _ in 0..<1000 {
            store.record(PlayResult(handCategory: .hard, handKey: "16", isCorrect: true))
        }
        // Buffer is capped at 1000; the wrong play should have been dropped
        let accuracy = store.overallAccuracy
        XCTAssertEqual(accuracy?.plays, 1000)
        XCTAssertEqual(accuracy?.correct, 1000)
    }

    func testOverallAccuracyEmpty() {
        let store = makeStore()
        XCTAssertNil(store.overallAccuracy)
    }

    func testOverallAccuracyMixed() {
        let store = makeStore()
        store.record(PlayResult(handCategory: .hard, handKey: "16", isCorrect: true))
        store.record(PlayResult(handCategory: .hard, handKey: "16", isCorrect: true))
        store.record(PlayResult(handCategory: .hard, handKey: "16", isCorrect: false))
        let accuracy = store.overallAccuracy
        XCTAssertEqual(accuracy?.plays, 3)
        XCTAssertEqual(accuracy?.correct, 2)
    }

    func testCategoryAccuracy() {
        let store = makeStore()
        store.record(PlayResult(handCategory: .hard, handKey: "16", isCorrect: true))
        store.record(PlayResult(handCategory: .hard, handKey: "12", isCorrect: false))
        store.record(PlayResult(handCategory: .soft, handKey: "A,6", isCorrect: true))
        store.record(PlayResult(handCategory: .pairs, handKey: "8,8", isCorrect: true))

        let hardAccuracy = store.categoryAccuracy(for: .hard)
        XCTAssertEqual(hardAccuracy?.plays, 2)
        XCTAssertEqual(hardAccuracy?.correct, 1)

        let softAccuracy = store.categoryAccuracy(for: .soft)
        XCTAssertEqual(softAccuracy?.plays, 1)
        XCTAssertEqual(softAccuracy?.correct, 1)

        let pairsAccuracy = store.categoryAccuracy(for: .pairs)
        XCTAssertEqual(pairsAccuracy?.plays, 1)
        XCTAssertEqual(pairsAccuracy?.correct, 1)
    }

    func testHandAccuracy() {
        let store = makeStore()
        store.record(PlayResult(handCategory: .hard, handKey: "16", isCorrect: true))
        store.record(PlayResult(handCategory: .hard, handKey: "16", isCorrect: false))
        store.record(PlayResult(handCategory: .hard, handKey: "12", isCorrect: true))

        let sixteenAccuracy = store.handAccuracy(category: .hard, key: "16")
        XCTAssertEqual(sixteenAccuracy?.plays, 2)
        XCTAssertEqual(sixteenAccuracy?.correct, 1)

        let twelveAccuracy = store.handAccuracy(category: .hard, key: "12")
        XCTAssertEqual(twelveAccuracy?.plays, 1)
        XCTAssertEqual(twelveAccuracy?.correct, 1)

        // Key not seen should return nil
        XCTAssertNil(store.handAccuracy(category: .hard, key: "20"))
    }

    func testReset() {
        let store = makeStore()
        store.record(PlayResult(handCategory: .hard, handKey: "16", isCorrect: true))
        store.reset()
        XCTAssertNil(store.overallAccuracy)
    }

    // MARK: - Review Data

    func testPlayResultDecodesLegacyFormat() throws {
        // Legacy JSON lacks the review fields added for the Hand Review feature.
        let legacyJSON = """
        {
            "handCategory": "Hard",
            "handKey": "16",
            "isCorrect": false
        }
        """.data(using: .utf8)!

        let result = try JSONDecoder().decode(PlayResult.self, from: legacyJSON)
        XCTAssertEqual(result.handCategory, .hard)
        XCTAssertEqual(result.handKey, "16")
        XCTAssertFalse(result.isCorrect)
        XCTAssertNil(result.dealerKey)
        XCTAssertNil(result.playerAction)
        XCTAssertNil(result.correctAction)
        XCTAssertNil(result.advice)
    }

    func testPlayResultRoundTripsReviewFields() throws {
        let original = PlayResult(
            handCategory: .hard,
            handKey: "16",
            isCorrect: false,
            dealerKey: "10",
            playerAction: "S",
            correctAction: "H",
            advice: "Hit hard 16 against dealer 10."
        )
        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(PlayResult.self, from: data)

        XCTAssertEqual(decoded.handCategory, original.handCategory)
        XCTAssertEqual(decoded.handKey, original.handKey)
        XCTAssertEqual(decoded.isCorrect, original.isCorrect)
        XCTAssertEqual(decoded.dealerKey, original.dealerKey)
        XCTAssertEqual(decoded.playerAction, original.playerAction)
        XCTAssertEqual(decoded.correctAction, original.correctAction)
        XCTAssertEqual(decoded.advice, original.advice)
    }

    func testReviewableResultsExcludesLegacyEntries() {
        let store = makeStore()
        // Legacy-shaped entry (no dealerKey) — must NOT appear in review.
        store.record(PlayResult(handCategory: .hard, handKey: "16", isCorrect: false))
        // New-format entries with full review data.
        store.record(PlayResult(
            handCategory: .hard, handKey: "12", isCorrect: true,
            dealerKey: "6", playerAction: "S", correctAction: "S",
            advice: "Stand hard 12 vs dealer 6."
        ))
        store.record(PlayResult(
            handCategory: .soft, handKey: "A,7", isCorrect: false,
            dealerKey: "9", playerAction: "S", correctAction: "H",
            advice: "Hit soft 18 vs dealer 9."
        ))

        let all = store.reviewableResults(incorrectOnly: false)
        XCTAssertEqual(all.count, 2)
        // Newest first: A,7 was recorded last.
        XCTAssertEqual(all.first?.handKey, "A,7")
        XCTAssertEqual(all.last?.handKey, "12")

        let incorrect = store.reviewableResults(incorrectOnly: true)
        XCTAssertEqual(incorrect.count, 1)
        XCTAssertEqual(incorrect.first?.handKey, "A,7")
    }

    func testPersistence() throws {
        let suiteName = "TestStatistics"
        let defaults = UserDefaults(suiteName: suiteName)!
        defaults.removePersistentDomain(forName: suiteName)

        let store1 = StatisticsStore(defaults: defaults)
        store1.record(PlayResult(handCategory: .hard, handKey: "16", isCorrect: true))
        store1.record(PlayResult(handCategory: .soft, handKey: "A,6", isCorrect: false))

        // New store with the same defaults should reload persisted data
        let store2 = StatisticsStore(defaults: defaults)
        let accuracy = store2.overallAccuracy
        XCTAssertEqual(accuracy?.plays, 2)
        XCTAssertEqual(accuracy?.correct, 1)

        // Clean up
        defaults.removePersistentDomain(forName: suiteName)
    }
}
