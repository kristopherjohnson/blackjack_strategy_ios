# Blackjack Strategy App Specification

## Overview
An iOS iPhone app for memorizing and practicing basic blackjack strategy. The app presents blackjack scenarios and validates user responses, providing corrective feedback when answers are incorrect.

## Goals
- Help users memorize basic blackjack strategy through practice
- Provide immediate feedback on correctness
- Include reference material for learning
- Start with MVP functionality for rapid delivery

## Target Platforms
- iOS 26+ (latest major stable release)
- iPhone and iPad (universal app with full-screen support)
- Built with latest Xcode
- Not distributed via App Store (personal use)

## App Identity
- **Name**: Blackjack Strategy
- **Bundle ID**: net.kristopherjohnson.blackjack_strategy
- **App Icon**: Jack of Spades (J♠) over a green felt background
  - Background: playfield green (`Color.green.opacity(0.15)` over black, matching app background)
  - Card: white/light card face with black suit and rank text
  - Simple, clean design readable at all icon sizes (20pt–1024pt)

## Features

### Practice Mode (Tab 1)
- Display player's two cards
- Display dealer's showing card
- Present four action buttons: Hit, Stand, Split, Double
  - Invalid actions disabled (e.g., Split disabled for non-pairs)
- Validate user's choice against basic strategy
- Show "correct" or "wrong" result
- When wrong, provide mnemonic or general principle for remembering correct play
- Tap to continue to next hand after feedback
- **Practice mode toggle** (segmented picker in toolbar): Uniform or Weighted
  - **Uniform**: Hands generated with equal probability across all non-blackjack two-card hands
  - **Weighted**: Biases hand generation toward hands the player gets wrong most often
    - Uses inverse-accuracy formula: lower accuracy → higher frequency
    - Requires ≥20 total plays before activating (falls back to uniform otherwise)
    - Per-hand threshold: ≥10 plays before accuracy influences that hand's weight
    - All hands still appear (minimum weight floor prevents any hand from disappearing)
    - Mode persisted across app sessions via UserDefaults
- **Blackjack handling**: If player is dealt 21 (blackjack), automatically re-deal
  - Blackjack is an automatic win, so there's no strategy decision to practice
  - Continue re-dealing until a non-blackjack hand is generated

### Reference Mode (Tab 2)
- Interactive strategy table (not static image)
- Allow easy lookup of correct plays by hand type and dealer card
- Organized by: Hard totals, Soft totals, Pairs

### Statistics Mode (Tab 3)
- Track accuracy of user's last 1000 plays (rolling window)
- **Overall accuracy**: percentage of correct decisions across all plays
- **Breakdown by hand category**: separate accuracy rates for Hard totals, Soft totals, and Pairs
- **Breakdown by specific hand**: accuracy per hand value (e.g., Hard 16, Soft A,7, Pair 8,8)
- **Reset button**: clears all statistics counters to zero (with confirmation prompt)
- **Persistence**: statistics saved across app sessions using UserDefaults
- Rolling window: once 1000 plays are recorded, oldest play is dropped when new play is added
- Display shows count of plays and percentage correct for each group
- Groups with zero plays show "—" instead of a percentage

### Hand Review (sub-screen of Statistics Mode)
- **Purpose**: lets the user review recent practice hands, especially mistakes, to understand what they played vs. what the correct action was
- **Entry point**: NavigationLink at the top of the Statistics tab labeled "Review Recent Hands"
- **Filter control**: segmented picker with two options — "Incorrect" (default) and "All"
- **Row contents**: hand description (e.g. "Hard 16 vs dealer 10"), the player's chosen action, the correct action, and the strategy advice text for incorrect plays
- **Ordering**: newest plays first
- **Empty state**: uses `ContentUnavailableView` when no reviewable entries match the current filter
- **Data source**: pulls from the same rolling buffer as the statistics display; entries recorded before the review feature shipped lack review data and are excluded from the list but still count for accuracy statistics

## User Interface
- Three-tab interface (TabView)
- **Action color scheme** (shared across Practice and Reference screens via `ActionColor`):
  - Hit → green
  - Stand → red
  - Double → orange
  - Split → blue
  - Used for the Practice action buttons, the Reference chart cells and legend, the "Correct play" label in Practice feedback, and the action names in Hand Review rows
- **Dark mode only**: App always displays in dark mode regardless of system settings
  - All `#Preview` blocks must apply `.preferredColorScheme(.dark)` so Xcode previews match the app's actual appearance
- **Launch screen**: App launch screen uses playfield background color (green opacity 0.15), not plain white
- **UI Animations**: Smooth animations during transitions where UI elements appear, disappear, or change
  - Fade in/out for feedback display and dismissal
  - Smooth transitions when changing cards between hands
  - Animated state changes for buttons (enabled/disabled)
  - Tab switching animations (built-in TabView transitions)
- Card display using text and SF Symbols
  - Red color for hearts (♥) and diamonds (♦)
  - Black color for clubs (♣) and spades (♠)
  - **Responsive sizing**: Card height at 22.5% of screen height (50% taller than original 15%)
  - Maximum card height capped at 180pt for very large screens
  - Maintains readability across different iPhone screen sizes
  - **No border**: Cards have no outline/border (clean appearance)
- Action buttons (4 buttons for player decisions)
  - Invalid actions visually disabled
- Feedback display area with tap-to-continue
  - Adaptive colors optimized for dark mode
  - **Multiline advice text**: Advice text displays in multiple lines if necessary, no truncation
  - **Flexible feedback container**: Feedback view expands to accommodate long advice strings
- **Compact layout**: Reduced vertical spacing between dealer's hand, player's hand, and action buttons for efficient use of screen space
- **Adaptive orientation layout**:
  - Portrait: Vertical layout (dealer top, player middle, buttons bottom)
  - Landscape Left: Horizontal split (cards on left, buttons/results on right)
  - Landscape Right: Horizontal split (cards on right, buttons/results on left)
- Interactive strategy table viewer

## Strategy Rules (Most Common Variant)
- 4-8 deck shoe assumed
- Dealer stands on soft 17
- Double allowed on any two cards
- Split allowed on pairs (including split Aces once)
- No surrender
- No insurance considerations (always decline)

## Technical Requirements
- Swift/SwiftUI
- iOS deployment target: iOS 26+
- Xcode: latest version
- No third-party dependencies
- Strategy table stored in external data file (JSON or similar)
  - Enables future rule variations without code changes
  - Includes mnemonics/advice for each scenario
- Doc comments on all public structs, classes, enums, and their members
- Animation logic separated from model layer (withAnimation in views only)

## Constraints
- MVP scope: minimal features only
- No backend/networking required
- No user accounts
- Development prioritizes simplicity over polish

## Out of Scope (for MVP)
- Advanced strategy (card counting, deviations)
- Rule variation selection (data file structure supports future addition)
- Sound effects
- Advanced animations (spring animations, complex transitions)
- App Store distribution
- Accessibility features beyond iOS defaults
- iPad-specific optimizations (uses responsive layout designed for iPhone)
