import SwiftUI

struct StatisticsView: View {
    var statisticsStore: StatisticsStore

    @State private var showingResetAlert = false

    var body: some View {
        NavigationStack {
            List {
                overallSection
                categorySection
                byHandSection
            }
            .navigationTitle("Statistics")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
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

    private var overallSection: some View {
        Section("Overall") {
            accuracyRow(
                label: "All Hands",
                accuracy: statisticsStore.overallAccuracy
            )
        }
    }

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

    private func formatAccuracy(_ accuracy: (plays: Int, correct: Int)) -> String {
        guard accuracy.plays > 0 else { return "—" }
        let pct = Int((Double(accuracy.correct) / Double(accuracy.plays) * 100).rounded())
        return "\(pct)%"
    }
}

#Preview {
    StatisticsView(statisticsStore: StatisticsStore())
}
