import SwiftUI

/// Shared color scheme for blackjack actions, used by both the Practice and Reference screens.
enum ActionColor {
    /// Color for the Hit action.
    static let hit = Color.green

    /// Color for the Stand action.
    static let stand = Color.red

    /// Color for the Double action.
    static let double = Color.orange

    /// Color for the Split action.
    static let split = Color.blue

    /// Returns the display color for a given player action.
    static func color(for action: PlayerAction) -> Color {
        switch action {
        case .hit: hit
        case .stand: stand
        case .double: double
        case .split: split
        }
    }

    /// Returns the display color for an action raw code ("H", "S", "D", "P"), or gray if unrecognized.
    static func color(forRawAction raw: String) -> Color {
        PlayerAction(rawValue: raw).map(color(for:)) ?? .gray
    }
}
