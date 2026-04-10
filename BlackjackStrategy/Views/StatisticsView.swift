import SwiftUI

/// The statistics tab: displays rolling accuracy broken down by overall, category, and individual hand.
struct StatisticsView: View {
    /// The statistics store to read and reset.
    var statisticsStore: StatisticsStore

    /// Whether the reset confirmation alert is showing.
    @State private var showingResetAlert = false

    var body: some View {
        NavigationStack {
            List {
                reviewSection
                overallSection
                categorySection
                byHandSection
            }
            .navigationTitle("Statistics")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Reset") {
                        showingResetAlert = true
                    }
                    .foregroundStyle(.red)
                }
            }
            .alert("Reset Statistics", isPresented: $showingResetAlert) {
                Button("Reset", role: .destructive) {
                    statisticsStore.reset()
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("All statistics data will be cleared. This cannot be undone.")
            }
        }
    }

    // MARK: - Sections

    /// Section containing the link to the Hand Review screen.
    private var reviewSection: some View {
        Section {
            NavigationLink {
                HandReviewView(statisticsStore: statisticsStore)
            } label: {
                Label("Review Recent Hands", systemImage: "magnifyingglass")
            }
        }
    }

    /// Section showing total plays and overall accuracy percentage.
    private var overallSection: some View {
        Section("Overall") {
            accuracyRow(
                label: "All Hands",
                accuracy: statisticsStore.overallAccuracy
            )
        }
    }

    /// Section showing accuracy for each hand category (hard, soft, pairs).
    private var categorySection: some View {
        Section("By Category") {
            accuracyRow(
                label: "Hard Totals",
                accuracy: statisticsStore.categoryAccuracy(for: .hard)
            )
            accuracyRow(
                label: "Soft Totals",
                accuracy: statisticsStore.categoryAccuracy(for: .soft)
            )
            accuracyRow(
                label: "Pairs",
                accuracy: statisticsStore.categoryAccuracy(for: .pairs)
            )
        }
    }

    /// Expandable sections showing per-hand accuracy within each category.
    @ViewBuilder
    private var byHandSection: some View {
        let hardKeys = statisticsStore.allHandKeys(for: .hard)
        let softKeys = statisticsStore.allHandKeys(for: .soft)
        let pairKeys = statisticsStore.allHandKeys(for: .pairs)

        if !hardKeys.isEmpty {
            Section("Hard Totals") {
                ForEach(hardKeys, id: \.self) { key in
                    handRow(category: .hard, key: key)
                }
            }
        }

        if !softKeys.isEmpty {
            Section("Soft Totals") {
                ForEach(softKeys, id: \.self) { key in
                    handRow(category: .soft, key: key)
                }
            }
        }

        if !pairKeys.isEmpty {
            Section("Pairs") {
                ForEach(pairKeys, id: \.self) { key in
                    handRow(category: .pairs, key: key)
                }
            }
        }
    }

    // MARK: - Row Helpers

    /// A row displaying a label, play count, and accuracy percentage (or "—" if no data).
    private func accuracyRow(label: String, accuracy: (plays: Int, correct: Int)?) -> some View {
        HStack {
            Text(label)
                .foregroundStyle(.primary)
            Spacer()
            if let accuracy {
                Text("\(accuracy.plays) plays")
                    .foregroundStyle(.secondary)
                    .font(.subheadline)
                Text(formatAccuracy(accuracy))
                    .foregroundStyle(.primary)
                    .font(.subheadline)
                    .monospacedDigit()
                    .frame(minWidth: 44, alignment: .trailing)
            } else {
                Text("—")
                    .foregroundStyle(.secondary)
            }
        }
    }

    /// A row for a specific hand key showing its play count and accuracy.
    private func handRow(category: HandCategory, key: String) -> some View {
        let accuracy = statisticsStore.handAccuracy(category: category, key: key)
        return HStack {
            Text(key)
                .foregroundStyle(.primary)
            Spacer()
            if let accuracy {
                Text("\(accuracy.plays)")
                    .foregroundStyle(.secondary)
                    .font(.subheadline)
                Text(formatAccuracy(accuracy))
                    .foregroundStyle(.primary)
                    .font(.subheadline)
                    .monospacedDigit()
                    .frame(minWidth: 44, alignment: .trailing)
            } else {
                Text("—")
                    .foregroundStyle(.secondary)
            }
        }
    }

    // MARK: - Formatting

    /// Formats an accuracy tuple as a rounded percentage string (e.g. "85%"), or "—" for zero plays.
    private func formatAccuracy(_ accuracy: (plays: Int, correct: Int)) -> String {
        guard accuracy.plays > 0 else { return "—" }
        let pct = Int((Double(accuracy.correct) / Double(accuracy.plays) * 100).rounded())
        return "\(pct)%"
    }
}

#Preview {
    StatisticsView(statisticsStore: StatisticsStore())
        .preferredColorScheme(.dark)
}
