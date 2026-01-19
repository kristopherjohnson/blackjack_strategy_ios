import SwiftUI

struct ReferenceView: View {
    private let strategy = StrategyData()
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

    private var legendView: some View {
        HStack(spacing: 16) {
            legendItem(label: "Hit", color: .blue)
            legendItem(label: "Stand", color: .red)
            legendItem(label: "Double", color: .green)
            legendItem(label: "Split", color: .purple)
        }
        .font(.caption)
    }

    private func legendItem(label: String, color: Color) -> some View {
        HStack(spacing: 4) {
            Circle()
                .fill(color)
                .frame(width: 12, height: 12)
            Text(label)
        }
    }

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
                            .foregroundColor(.white)
                    }
                }
            }
        }
    }

    private var currentRows: [String] {
        switch selectedSection {
        case .hard: strategy.hardTotals
        case .soft: strategy.softTotals
        case .pair: strategy.pairTotals
        }
    }

    private func colorForAction(_ action: String) -> Color {
        switch action {
        case "H": .blue
        case "S": .red
        case "D": .green
        case "P": .purple
        default: .gray
        }
    }
}

#Preview {
    ReferenceView()
}
