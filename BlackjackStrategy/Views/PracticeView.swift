import SwiftUI

struct PracticeView: View {
    @State private var gameState = GameState()
    private let strategy = StrategyData()

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            VStack(spacing: 8) {
                Text("Dealer Shows")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                CardView(card: gameState.dealerCard)
            }

            Spacer()

            VStack(spacing: 8) {
                Text("Your Hand")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                HStack(spacing: 12) {
                    ForEach(Array(gameState.playerHand.cards.enumerated()), id: \.offset) { _, card in
                        CardView(card: card)
                    }
                }
                Text(handDescription)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            switch gameState.practiceState {
            case .awaitingAction:
                actionButtons
            case .showingResult(let correct, let correctAction, let advice):
                feedbackView(correct: correct, correctAction: correctAction, advice: advice)
            }

            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.green.opacity(0.15))
    }

    private var handDescription: String {
        let hand = gameState.playerHand
        if hand.isPair {
            return "Pair (\(hand.bestTotal))"
        } else if hand.isSoft {
            return "Soft \(hand.bestTotal)"
        } else {
            return "Hard \(hand.bestTotal)"
        }
    }

    private var actionButtons: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                actionButton(action: .hit, color: .blue)
                actionButton(action: .stand, color: .orange)
            }
            HStack(spacing: 12) {
                actionButton(action: .double, color: .purple)
                actionButton(action: .split, color: .green)
            }
        }
    }

    private func actionButton(action: PlayerAction, color: Color) -> some View {
        let isDisabled = action == .split && !gameState.canSplit
        return Button {
            gameState.checkAction(action, strategy: strategy)
        } label: {
            Text(action.displayName)
                .font(.headline)
                .foregroundStyle(.white)
                .frame(width: 120, height: 50)
                .background(color)
                .cornerRadius(10)
        }
        .disabled(isDisabled)
        .opacity(isDisabled ? 0.5 : 1.0)
    }

    private func feedbackView(correct: Bool, correctAction: PlayerAction, advice: String) -> some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: correct ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .font(.system(size: 40))
                Text(correct ? "Correct!" : "Wrong")
                    .font(.title)
                    .fontWeight(.bold)
            }
            .foregroundStyle(correct ? .green : .red)

            if !correct {
                VStack(spacing: 8) {
                    Text("Correct play: \(correctAction.displayName)")
                        .font(.headline)
                    Text(advice)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
            }

            Text("Tap to continue")
                .font(.caption)
                .foregroundStyle(.primary)
        }
        .padding()
        .background(.regularMaterial)
        .cornerRadius(12)
        .onTapGesture {
            gameState.newHand()
        }
    }
}

#Preview {
    PracticeView()
}
