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
