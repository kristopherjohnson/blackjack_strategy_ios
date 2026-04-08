import SwiftUI

/// The practice tab: presents random blackjack hands and validates the player's action against basic strategy.
struct PracticeView: View {
    /// Shared game state driving the practice loop.
    var gameState: GameState

    /// Strategy data used to validate player actions.
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

    /// Vertical layout for portrait orientation: dealer top, player middle, buttons/feedback bottom.
    private func portraitLayout(geometry: GeometryProxy) -> some View {
        VStack(spacing: 12) {
            Spacer(minLength: 0)

            dealerSection(cardHeight: cardHeight(for: geometry.size.height))

            Spacer(minLength: 8)

            playerSection(cardHeight: cardHeight(for: geometry.size.height))

            Spacer(minLength: 8)

            stateContent

            Spacer(minLength: 0)
        }
    }

    /// Horizontal layout for landscape orientation: cards on the left, buttons/feedback on the right.
    private func landscapeLayout(geometry: GeometryProxy) -> some View {
        HStack(spacing: 20) {
            VStack(spacing: 12) {
                Spacer(minLength: 0)

                dealerSection(cardHeight: cardHeight(for: geometry.size.height))

                Spacer(minLength: 8)

                playerSection(cardHeight: cardHeight(for: geometry.size.height))

                Spacer(minLength: 0)
            }
            .frame(maxWidth: .infinity)

            VStack {
                Spacer()
                stateContent
                Spacer()
            }
            .frame(maxWidth: .infinity)
        }
    }

    /// Displays the dealer's face-up card with a label.
    private func dealerSection(cardHeight: CGFloat) -> some View {
        VStack(spacing: 8) {
            Text("Dealer Shows")
                .font(.headline)
                .foregroundStyle(.secondary)
            CardView(card: gameState.dealerCard, height: cardHeight)
                .id(gameState.dealerCard.id)
        }
    }

    /// Displays the player's two-card hand with a label and hand description.
    private func playerSection(cardHeight: CGFloat) -> some View {
        VStack(spacing: 8) {
            Text("Your Hand")
                .font(.headline)
                .foregroundStyle(.secondary)
            HStack(spacing: 12) {
                ForEach(Array(gameState.playerHand.cards.enumerated()), id: \.offset) { index, card in
                    CardView(card: card, height: cardHeight)
                        .id("\(card.id)-\(index)")
                }
            }
            Text(handDescription)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }

    /// Shows action buttons when awaiting input, or feedback after the player acts.
    @ViewBuilder
    private var stateContent: some View {
        switch gameState.practiceState {
        case .awaitingAction:
            actionButtons
        case .showingResult(let correct, let correctAction, let advice):
            feedbackView(correct: correct, correctAction: correctAction, advice: advice)
        }
    }

    /// Calculates card height as 22.5% of screen height, capped at 180pt.
    private func cardHeight(for screenHeight: CGFloat) -> CGFloat {
        min(screenHeight * 0.225, 180)
    }

    /// Human-readable description of the player's hand type and total (e.g. "Soft 17", "Pair (16)").
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

    /// The four action buttons: Hit, Stand, Double, Split.
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

    /// A single action button, disabled when the action is invalid (e.g. Split on non-pairs).
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
        .animation(.easeInOut(duration: 0.2), value: isDisabled)
    }

    /// Feedback overlay showing whether the player was correct, with advice on wrong answers. Tap to continue.
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
    PracticeView(gameState: GameState())
        .preferredColorScheme(.dark)
}
