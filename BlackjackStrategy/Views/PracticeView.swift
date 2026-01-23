import SwiftUI

struct PracticeView: View {
    @State private var gameState = GameState()
    private let strategy = StrategyData()

    var body: some View {
        GeometryReader { geometry in
            let isLandscape = geometry.size.width > geometry.size.height

            Group {
                if isLandscape {
                    landscapeLayout(geometry: geometry)
                } else {
                    portraitLayout(geometry: geometry)
                }
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.green.opacity(0.15))
        }
    }

    private func portraitLayout(geometry: GeometryProxy) -> some View {
        VStack(spacing: 12) {
            Spacer(minLength: 0)

            VStack(spacing: 8) {
                Text("Dealer Shows")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                CardView(card: gameState.dealerCard, height: cardHeight(for: geometry.size.height))
            }

            Spacer(minLength: 8)

            VStack(spacing: 8) {
                Text("Your Hand")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                HStack(spacing: 12) {
                    ForEach(Array(gameState.playerHand.cards.enumerated()), id: \.offset) { _, card in
                        CardView(card: card, height: cardHeight(for: geometry.size.height))
                    }
                }
                Text(handDescription)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer(minLength: 8)

            switch gameState.practiceState {
            case .awaitingAction:
                actionButtons
            case .showingResult(let correct, let correctAction, let advice):
                feedbackView(correct: correct, correctAction: correctAction, advice: advice)
            }

            Spacer(minLength: 0)
        }
    }

    private func landscapeLayout(geometry: GeometryProxy) -> some View {
        HStack(spacing: 20) {
            // Cards section
            VStack(spacing: 12) {
                Spacer(minLength: 0)

                VStack(spacing: 8) {
                    Text("Dealer Shows")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                    CardView(card: gameState.dealerCard, height: cardHeight(for: geometry.size.height))
                }

                Spacer(minLength: 8)

                VStack(spacing: 8) {
                    Text("Your Hand")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                    HStack(spacing: 12) {
                        ForEach(Array(gameState.playerHand.cards.enumerated()), id: \.offset) { _, card in
                            CardView(card: card, height: cardHeight(for: geometry.size.height))
                        }
                    }
                    Text(handDescription)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Spacer(minLength: 0)
            }
            .frame(maxWidth: .infinity)

            // Buttons/Results section
            VStack {
                Spacer()

                switch gameState.practiceState {
                case .awaitingAction:
                    actionButtons
                case .showingResult(let correct, let correctAction, let advice):
                    feedbackView(correct: correct, correctAction: correctAction, advice: advice)
                }

                Spacer()
            }
            .frame(maxWidth: .infinity)
        }
    }

    private func cardHeight(for screenHeight: CGFloat) -> CGFloat {
        // Calculate card height as proportion of available screen height
        // Reserve space for: padding, labels, buttons, spacers
        // Cards at 22.5% of screen height (50% taller than original 15%)
        return min(screenHeight * 0.225, 180)
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
                        .fixedSize(horizontal: false, vertical: true)
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
