# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

iOS app for practicing basic blackjack strategy. Three-tab interface: Practice mode presents hands for user response validation, Reference mode displays interactive strategy charts, Statistics mode tracks rolling accuracy.

**Bundle ID**: net.kristopherjohnson.blackjack_strategy
**Deployment**: iOS 18+, iPhone and iPad, not App Store distributed

## Build Commands

```bash
# Build for simulator
xcodebuild -project BlackjackStrategy.xcodeproj -scheme BlackjackStrategy \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro' build

# Run tests
xcodebuild -project BlackjackStrategy.xcodeproj -scheme BlackjackStrategy \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro' test
```

## Architecture

### Data Flow
- `strategy.json` → `StrategyData` (loaded at init) → `GameState` (validates actions) → `PracticeView` (displays feedback)
- Strategy lookup uses composite keys: hard totals ("12"-"20"), soft totals ("A,2"-"A,9"), pairs ("8,8", "A,A")

### Key Models
- **Card/Hand**: Value calculations with blackjack-specific rules (Ace=1 or 11, face cards=10)
- **Hand.strategyKey**: Converts hand to lookup key based on isPair/isSoft/hardTotal
- **GameState**: `@Observable` class managing practice state machine (awaitingAction → showingResult). No SwiftUI imports — animation is handled in views.
- **StrategyData**: Loads JSON, provides `getCorrectAction()` and `getAdvice()` lookups
- **StatisticsStore**: Rolling buffer of last 1000 plays, persisted via UserDefaults, provides per-hand/category accuracy
- **WeightedHandGenerator**: Precomputes combo table mapping 34 strategy keys to valid card pairs. Generates hands biased toward low-accuracy keys using inverse-accuracy weighting.

### Strategy Rules (4-8 deck, dealer stands soft 17)
- 340 total entries: 160 hard + 80 soft + 100 pairs
- Actions: H(it), S(tand), D(ouble), P(split)
- Blackjacks auto-redeal (no strategy decision needed)

### Views
- `ContentView`: TabView container (3 tabs: Practice, Reference, Statistics)
- `PracticeView`: Game loop UI with CardView components, Uniform/Weighted mode picker in toolbar
- `ReferenceView`: Interactive Grid-based strategy table with section picker
- `StatisticsView`: Overall, per-category, and per-hand accuracy display with reset

## Testing

102 unit tests covering Card, Hand, StrategyData loading, strategy logic, StatisticsStore, and WeightedHandGenerator. Tests verify all 340 strategy entries exist with valid actions and non-empty advice.

## Documentation

The `specs/` directory contains project specifications:
- `SPECIFICATION.md` - Feature requirements and technical constraints
- `IMPLEMENTATION_PLAN.md` - Development phases and status
- `TEST_PLAN.md` - Testing approach
- `DECISION_LOG.md` - Design decisions
