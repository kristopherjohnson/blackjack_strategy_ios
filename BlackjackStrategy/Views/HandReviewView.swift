import SwiftUI

/// Displays a reviewable list of recent practice plays so the user can study their mistakes.
struct HandReviewView: View {
    /// Source of recorded play results.
    var statisticsStore: StatisticsStore

    /// Filter selection controlling whether to show only incorrect plays or all reviewable plays.
    @State private var filter: ReviewFilter = .incorrect

    /// Available filters for the review list.
    private enum ReviewFilter: String, CaseIterable, Identifiable {
        case incorrect = "Incorrect"
        case all = "All"

        var id: String { rawValue }
    }

    /// Currently displayed results after applying the filter.
    private var results: [PlayResult] {
        statisticsStore.reviewableResults(incorrectOnly: filter == .incorrect)
    }

    var body: some View {
        VStack(spacing: 0) {
            Picker("Filter", selection: $filter) {
                ForEach(ReviewFilter.allCases) { filter in
                    Text(filter.rawValue).tag(filter)
                }
            }
            .pickerStyle(.segmented)
            .padding()

            if results.isEmpty {
                ContentUnavailableView(
                    filter == .incorrect ? "No Incorrect Plays" : "No Plays to Review",
                    systemImage: "checkmark.circle",
                    description: Text(emptyDescription)
                )
            } else {
                List(results) { result in
                    ReviewRowView(result: result)
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle("Hand Review")
        .navigationBarTitleDisplayMode(.inline)
    }

    /// Explanation text shown beneath the empty-state title.
    private var emptyDescription: String {
        switch filter {
        case .incorrect:
            return "You haven't made any mistakes in recent plays. Keep practicing!"
        case .all:
            return "Play some hands in Practice mode to review them here."
        }
    }
}

/// A single row in the hand review list, summarizing one play.
struct ReviewRowView: View {
    /// The play result to display.
    let result: PlayResult

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(handDescription)
                    .font(.headline)
                Spacer()
                Image(systemName: result.isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .foregroundStyle(result.isCorrect ? .green : .red)
            }

            HStack(spacing: 16) {
                labeledValue(
                    label: "You played",
                    value: actionName(result.playerAction),
                    color: actionColor(result.playerAction)
                )
                labeledValue(
                    label: "Correct",
                    value: actionName(result.correctAction),
                    color: actionColor(result.correctAction)
                )
            }
            .font(.subheadline)

            if !result.isCorrect, let advice = result.advice, !advice.isEmpty {
                Text(advice)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(.vertical, 4)
    }

    /// Human-readable description of the hand and dealer up-card.
    private var handDescription: String {
        let handText: String
        switch result.handCategory {
        case .hard:
            handText = "Hard \(result.handKey)"
        case .soft:
            handText = "Soft \(result.handKey)"
        case .pairs:
            handText = "Pair \(result.handKey)"
        }
        if let dealerKey = result.dealerKey {
            return "\(handText) vs dealer \(dealerKey)"
        }
        return handText
    }

    /// Converts a raw action string ("H", "S", "D", "P") to its display name.
    private func actionName(_ raw: String?) -> String {
        guard let raw, let action = PlayerAction(rawValue: raw) else { return "—" }
        return action.displayName
    }

    /// Returns the canonical action color, or secondary gray for missing data.
    private func actionColor(_ raw: String?) -> Color {
        guard let raw else { return .secondary }
        return ActionColor.color(forRawAction: raw)
    }

    /// Renders a small label above a value, used to show "You played" and "Correct" columns.
    private func labeledValue(label: String, value: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
            Text(value)
                .foregroundStyle(color)
        }
    }
}

#Preview {
    NavigationStack {
        HandReviewView(statisticsStore: {
            let store = StatisticsStore(defaults: UserDefaults(suiteName: "Preview")!)
            store.reset()
            store.record(PlayResult(
                handCategory: .hard, handKey: "16", isCorrect: false,
                dealerKey: "10", playerAction: "S", correctAction: "H",
                advice: "Hit hard 16 against dealer 10 — standing loses more often."
            ))
            store.record(PlayResult(
                handCategory: .soft, handKey: "A,7", isCorrect: false,
                dealerKey: "9", playerAction: "S", correctAction: "H",
                advice: "Soft 18 vs 9: hit."
            ))
            store.record(PlayResult(
                handCategory: .pairs, handKey: "8,8", isCorrect: true,
                dealerKey: "10", playerAction: "P", correctAction: "P",
                advice: "Always split eights."
            ))
            return store
        }())
    }
    .preferredColorScheme(.dark)
}
