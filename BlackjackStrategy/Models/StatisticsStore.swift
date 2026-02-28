import Foundation

enum HandCategory: String, Codable, CaseIterable {
    case hard = "Hard"
    case soft = "Soft"
    case pairs = "Pairs"
}

struct PlayResult: Codable {
    let handCategory: HandCategory
    let handKey: String
    let isCorrect: Bool
}

@Observable
class StatisticsStore {
    private var results: [PlayResult] = []
    private let defaults: UserDefaults
    private let defaultsKey = "statisticsResults"

    // Rolling buffer limit
    private let bufferLimit = 1000

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        loadFromDefaults()
    }

    // MARK: - Recording

    func record(_ result: PlayResult) {
        results.append(result)
        // Drop oldest entry when over limit
        if results.count > bufferLimit {
            results.removeFirst()
        }
        saveToDefaults()
    }

    func reset() {
        results = []
        saveToDefaults()
    }

    // MARK: - Computed Statistics

    var overallAccuracy: (plays: Int, correct: Int)? {
        guard !results.isEmpty else { return nil }
        let correct = results.filter { $0.isCorrect }.count
        return (plays: results.count, correct: correct)
    }

    func categoryAccuracy(for category: HandCategory) -> (plays: Int, correct: Int)? {
        let filtered = results.filter { $0.handCategory == category }
        guard !filtered.isEmpty else { return nil }
        let correct = filtered.filter { $0.isCorrect }.count
        return (plays: filtered.count, correct: correct)
    }

    func handAccuracy(category: HandCategory, key: String) -> (plays: Int, correct: Int)? {
        let filtered = results.filter { $0.handCategory == category && $0.handKey == key }
        guard !filtered.isEmpty else { return nil }
        let correct = filtered.filter { $0.isCorrect }.count
        return (plays: filtered.count, correct: correct)
    }

    func allHandKeys(for category: HandCategory) -> [String] {
        let keys = Set(results.filter { $0.handCategory == category }.map { $0.handKey })
        return keys.sorted { sortKey($0, category: category) < sortKey($1, category: category) }
    }

    // MARK: - Persistence

    private func loadFromDefaults() {
        guard let data = defaults.data(forKey: defaultsKey),
              let decoded = try? JSONDecoder().decode([PlayResult].self, from: data)
        else {
            return
        }
        results = decoded
    }

    private func saveToDefaults() {
        guard let data = try? JSONEncoder().encode(results) else { return }
        defaults.set(data, forKey: defaultsKey)
    }

    // MARK: - Sorting Helpers

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

    private func pairSortValue(_ key: String) -> Int {
        switch key {
        case "A": return 14
        case "T", "J", "Q", "K": return 10
        default: return Int(key) ?? 0
        }
    }
}
