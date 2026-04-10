import SwiftUI

/// The reference tab: displays an interactive color-coded basic strategy chart.
struct ReferenceView: View {
    /// Strategy data providing table contents.
    private let strategy = StrategyData()

    /// Currently selected hand type section (hard, soft, or pairs).
    @State private var selectedSection = StrategyData.HandType.hard

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Picker("Section", selection: $selectedSection) {
                    Text("Hard").tag(StrategyData.HandType.hard)
                    Text("Soft").tag(StrategyData.HandType.soft)
                    Text("Pairs").tag(StrategyData.HandType.pair)
                }
                .pickerStyle(.segmented)
                .padding()

                legendView
                    .padding(.horizontal)
                    .padding(.bottom, 8)

                ScrollView([.horizontal, .vertical]) {
                    strategyTable
                        .padding()
                }
            }
            .navigationTitle("Strategy Chart")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    /// Color legend mapping action labels to their cell colors.
    private var legendView: some View {
        HStack(spacing: 16) {
            legendItem(label: "Hit", color: ActionColor.hit)
            legendItem(label: "Stand", color: ActionColor.stand)
            legendItem(label: "Double", color: ActionColor.double)
            legendItem(label: "Split", color: ActionColor.split)
        }
        .font(.caption)
    }

    /// A single legend entry: colored dot followed by action label.
    private func legendItem(label: String, color: Color) -> some View {
        HStack(spacing: 4) {
            Circle()
                .fill(color)
                .frame(width: 12, height: 12)
            Text(label)
        }
    }

    /// Grid of strategy cells: rows are player hands, columns are dealer up-cards.
    private var strategyTable: some View {
        Grid(horizontalSpacing: 2, verticalSpacing: 2) {
            GridRow {
                Text("")
                    .frame(width: 50, height: 30)
                ForEach(strategy.dealerCards, id: \.self) { dealer in
                    Text(dealer)
                        .font(.caption.bold())
                        .frame(width: 30, height: 30)
                        .background(Color.gray.opacity(0.3))
                }
            }

            ForEach(currentRows, id: \.self) { hand in
                GridRow {
                    Text(hand)
                        .font(.caption.bold())
                        .frame(width: 50, height: 30)
                        .background(Color.gray.opacity(0.3))

                    ForEach(strategy.dealerCards, id: \.self) { dealer in
                        let action = strategy.getAction(forHand: hand, dealer: dealer, type: selectedSection)
                        Text(action)
                            .font(.caption.bold())
                            .frame(width: 30, height: 30)
                            .background(colorForAction(action))
                            .foregroundStyle(.white)
                    }
                }
            }
        }
    }

    /// Row keys for the currently selected section.
    private var currentRows: [String] {
        switch selectedSection {
        case .hard: strategy.hardTotals
        case .soft: strategy.softTotals
        case .pair: strategy.pairTotals
        }
    }

    /// Maps an action code to its display color.
    private func colorForAction(_ action: String) -> Color {
        ActionColor.color(forRawAction: action)
    }
}

#Preview {
    ReferenceView()
        .preferredColorScheme(.dark)
}
