import Foundation

/// Classification of a blackjack hand for statistics grouping.
enum HandCategory: String, Codable, CaseIterable {
    case hard = "Hard"
    case soft = "Soft"
    case pairs = "Pairs"
}

/// The outcome of a single practice play, recorded for statistics.
struct PlayResult: Codable {
    /// Which hand category this play belonged to.
    let handCategory: HandCategory

    /// The strategy table key for the specific hand (e.g. "16", "A,7", "8,8").
    let handKey: String

    /// Whether the player chose the correct action.
    let isCorrect: Bool
}

/// Tracks rolling accuracy statistics over the last 1000 practice plays, persisted via UserDefaults.
@Observable
class StatisticsStore {
    /// All recorded play results, newest last.
    private var results: [PlayResult] = []

    /// The UserDefaults instance used for persistence.
    private let defaults: UserDefaults

    /// The UserDefaults key for storing encoded results.
    private let defaultsKey = "statisticsResults"

    /// Maximum number of results to retain (oldest are dropped).
    private let bufferLimit = 1000

    /// Initializes the store, loading any previously persisted results.
    ///
    /// - Parameter defaults: The UserDefaults suite to use. Pass a named suite for testing.
    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        loadFromDefaults()
    }

    // MARK: - Recording

    /// Records a play result, dropping the oldest entry if the buffer is full.
    func record(_ result: PlayResult) {
        results.append(result)
        // Drop oldest entry when over limit
        if results.count > bufferLimit {
            results.removeFirst()
        }
        saveToDefaults()
    }

    /// Clears all recorded results and persists the empty state.
    func reset() {
        results = []
        saveToDefaults()
    }

    // MARK: - Computed Statistics

    /// Overall play count and number correct, or `nil` if no plays recorded.
    var overallAccuracy: (plays: Int, correct: Int)? {
        guard !results.isEmpty else { return nil }
        let correct = results.filter { $0.isCorrect }.count
        return (plays: results.count, correct: correct)
    }

    /// Play count and number correct for a specific hand category, or `nil` if none recorded.
    func categoryAccuracy(for category: HandCategory) -> (plays: Int, correct: Int)? {
        let filtered = results.filter { $0.handCategory == category }
        guard !filtered.isEmpty else { return nil }
        let correct = filtered.filter { $0.isCorrect }.count
        return (plays: filtered.count, correct: correct)
    }

    /// Play count and number correct for a specific hand within a category, or `nil` if none recorded.
    func handAccuracy(category: HandCategory, key: String) -> (plays: Int, correct: Int)? {
        let filtered = results.filter { $0.handCategory == category && $0.handKey == key }
        guard !filtered.isEmpty else { return nil }
        let correct = filtered.filter { $0.isCorrect }.count
        return (plays: filtered.count, correct: correct)
    }

    /// Returns all distinct hand keys for a category, sorted in natural order.
    func allHandKeys(for category: HandCategory) -> [String] {
        let keys = Set(results.filter { $0.handCategory == category }.map { $0.handKey })
        return keys.sorted { sortKey($0, category: category) < sortKey($1, category: category) }
    }

    // MARK: - Persistence

    /// Loads previously saved results from UserDefaults.
    private func loadFromDefaults() {
        guard let data = defaults.data(forKey: defaultsKey),
              let decoded = try? JSONDecoder().decode([PlayResult].self, from: data)
        else {
            return
        }
        results = decoded
    }

    /// Encodes and saves current results to UserDefaults.
    private func saveToDefaults() {
        guard let data = try? JSONEncoder().encode(results) else { return }
        defaults.set(data, forKey: defaultsKey)
    }

    // MARK: - Sorting Helpers

    /// Converts a hand key to a numeric sort value for ordering within a category.
    private func sortKey(_ key: String, category: HandCategory) -> Int {
        switch category {
        case .hard:
            // Sort numerically by hard total
            return Int(key) ?? 0
        case .soft:
            // Sort by the second value in "A,N" — e.g. "A,2" < "A,9"
            let parts = key.split(separator: ",")
            return parts.count == 2 ? Int(parts[1]) ?? 0 : 0
        case .pairs:
            // Sort by card value: numeric ranks first, then T/J/Q/K=10, A=11
            let cardKey = String(key.split(separator: ",").first ?? "")
            return pairSortValue(cardKey)
        }
    }

    /// Maps a card key string to a numeric value for pair sorting.
    private func pairSortValue(_ key: String) -> Int {
        switch key {
        case "A": return 14
        case "T", "J", "Q", "K": return 10
        default: return Int(key) ?? 0
        }
    }
}
