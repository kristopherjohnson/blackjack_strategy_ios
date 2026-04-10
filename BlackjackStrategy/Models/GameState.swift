import Foundation

/// A player's possible actions in blackjack.
enum PlayerAction: String, CaseIterable {
    case hit = "H"
    case stand = "S"
    case double = "D"
    case split = "P"

    /// Human-readable name for the action.
    var displayName: String {
        switch self {
        case .hit: return "Hit"
        case .stand: return "Stand"
        case .double: return "Double"
        case .split: return "Split"
        }
    }
}

/// The current state of the practice mode UI.
enum PracticeState {
    /// Waiting for the player to choose an action.
    case awaitingAction

    /// Showing feedback after the player's choice.
    case showingResult(correct: Bool, correctAction: PlayerAction, advice: String)
}

/// Observable state machine driving the practice mode game loop.
@Observable
class GameState {
    /// The player's current two-card hand.
    var playerHand: Hand

    /// The dealer's face-up card.
    var dealerCard: Card

    /// Current phase of the practice round.
    var practiceState: PracticeState = .awaitingAction

    /// Tracks rolling accuracy statistics across practice sessions.
    var statisticsStore: StatisticsStore = StatisticsStore()

    /// Whether hand generation is uniform or weighted toward weak hands.
    var practiceMode: PracticeMode = .uniform {
        didSet {
            UserDefaults.standard.set(practiceMode.rawValue, forKey: "practiceMode")
        }
    }

    /// Generator for weighted hand selection.
    private let weightedGenerator = WeightedHandGenerator()

    /// Initializes with a random non-blackjack hand and dealer card.
    init() {
        if let saved = UserDefaults.standard.string(forKey: "practiceMode"),
           let mode = PracticeMode(rawValue: saved) {
            practiceMode = mode
        }
        playerHand = Hand.randomTwoCard()
        dealerCard = Card.random()
    }

    /// Whether the player's hand is a pair and can be split.
    var canSplit: Bool {
        playerHand.isPair
    }

    /// Deals a new hand and resets to the awaiting-action state.
    ///
    /// In weighted mode, biases toward hands the player gets wrong most often.
    func newHand() {
        if practiceMode == .weighted {
            let result = weightedGenerator.generateHand(using: statisticsStore)
            playerHand = result.hand
            dealerCard = result.dealerCard
        } else {
            playerHand = Hand.randomTwoCard()
            dealerCard = Card.random()
        }
        practiceState = .awaitingAction
    }

    /// Validates the player's action against basic strategy, records the result, and transitions to the feedback state.
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

        // Record result for statistics tracking
        let category: HandCategory
        if playerHand.isPair {
            category = .pairs
        } else if playerHand.isSoft {
            category = .soft
        } else {
            category = .hard
        }
        statisticsStore.record(PlayResult(
            handCategory: category,
            handKey: playerHand.strategyKey,
            isCorrect: isCorrect,
            dealerKey: dealerCard.rank.strategyKey,
            playerAction: action.rawValue,
            correctAction: correctAction.rawValue,
            advice: advice
        ))

        practiceState = .showingResult(
            correct: isCorrect,
            correctAction: correctAction,
            advice: advice
        )
    }
}
