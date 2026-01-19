# Blackjack Strategy App Specification

## Overview
An iOS iPhone app for memorizing and practicing basic blackjack strategy. The app presents blackjack scenarios and validates user responses, providing corrective feedback when answers are incorrect.

## Goals
- Help users memorize basic blackjack strategy through practice
- Provide immediate feedback on correctness
- Include reference material for learning
- Start with MVP functionality for rapid delivery

## Target Platforms
- iOS 18+ (latest major stable release)
- iPhone (not iPad-optimized initially)
- Built with latest Xcode
- Not distributed via App Store (personal use)

## App Identity
- **Name**: Blackjack Strategy
- **Bundle ID**: net.kristopherjohnson.blackjack_strategy

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
- Hands generated randomly (no weighting)
- **Blackjack handling**: If player is dealt 21 (blackjack), automatically re-deal
  - Blackjack is an automatic win, so there's no strategy decision to practice
  - Continue re-dealing until a non-blackjack hand is generated

### Reference Mode (Tab 2)
- Interactive strategy table (not static image)
- Allow easy lookup of correct plays by hand type and dealer card
- Organized by: Hard totals, Soft totals, Pairs

## User Interface
- Two-tab interface (TabView)
- Card display using text and SF Symbols
  - Red color for hearts (♥) and diamonds (♦)
  - Black color for clubs (♣) and spades (♠)
- Action buttons (4 buttons for player decisions)
  - Invalid actions visually disabled
- Feedback display area with tap-to-continue
  - "Tap to Continue" label must be visible in both light and dark modes
  - Use adaptive colors that maintain visibility across appearance modes
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
- iOS deployment target: iOS 18+
- Xcode: latest version
- No third-party dependencies
- Strategy table stored in external data file (JSON or similar)
  - Enables future rule variations without code changes
  - Includes mnemonics/advice for each scenario

## Constraints
- MVP scope: minimal features only
- No backend/networking required
- No user accounts or progress tracking (initially)
- Development prioritizes simplicity over polish

## Out of Scope (for MVP)
- iPad optimization
- Advanced strategy (card counting, deviations)
- Rule variation selection (data file structure supports future addition)
- Statistics/progress tracking
- Sound effects or animations
- App Store distribution
- Accessibility features beyond iOS defaults
