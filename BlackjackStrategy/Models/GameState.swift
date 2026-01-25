import Foundation
import SwiftUI

// Consistent animation timing for state transitions
private let stateTransitionAnimation = Animation.easeInOut(duration: 0.3)

enum PlayerAction: String, CaseIterable {
    case hit = "H"
    case stand = "S"
    case double = "D"
    case split = "P"

    var displayName: String {
        switch self {
        case .hit: return "Hit"
        case .stand: return "Stand"
        case .double: return "Double"
        case .split: return "Split"
        }
    }
}

enum PracticeState {
    case awaitingAction
    case showingResult(correct: Bool, correctAction: PlayerAction, advice: String)
}

@Observable
class GameState {
    var playerHand: Hand
    var dealerCard: Card
    var practiceState: PracticeState = .awaitingAction

    init() {
        playerHand = Hand.randomTwoCard()
        dealerCard = Card.random()
    }

    var canSplit: Bool {
        playerHand.isPair
    }

    func newHand() {
        withAnimation(stateTransitionAnimation) {
            playerHand = Hand.randomTwoCard()
            dealerCard = Card.random()
            practiceState = .awaitingAction
        }
    }

    func checkAction(_ action: PlayerAction, strategy: StrategyData) {
        let correctAction = strategy.getCorrectAction(
            handKey: playerHand.strategyKey,
            dealerKey: dealerCard.rank.strategyKey,
            isPair: playerHand.isPair,
            isSoft: playerHand.isSoft
        )

        let advice = strategy.getAdvice(
            handKey: playerHand.strategyKey,
            dealerKey: dealerCard.rank.strategyKey,
            isPair: playerHand.isPair,
            isSoft: playerHand.isSoft
        )

        let isCorrect = action == correctAction
        withAnimation(stateTransitionAnimation) {
            practiceState = .showingResult(
                correct: isCorrect,
                correctAction: correctAction,
                advice: advice
            )
        }
    }
}
