# Implementation Plan

## Phase 1: Project Setup
- [x] Create new Xcode project with correct name and bundle ID
- [x] Set up basic SwiftUI app structure
- [x] Configure iOS deployment target to latest version
- [x] Verify project builds successfully

## Phase 2: Data Models & Strategy Data
- [x] Define Card model (rank, suit, with text/SF Symbol display)
- [x] Define Hand model (player's two cards, value calculation, pair detection)
- [x] Define GameState model (player hand, dealer card, current state)
- [x] Create JSON schema for strategy data file
- [x] Populate strategy JSON with all scenarios (hard, soft, pairs)
- [x] Include mnemonics/advice in JSON for each scenario
- [x] Implement strategy data loader from JSON bundle resource

## Phase 3: Practice Mode UI
- [x] Create main TabView structure
- [x] Build practice tab layout
- [x] Implement CardView component (text + SF Symbols, red/black coloring)
- [x] Create four action buttons (Hit, Stand, Split, Double)
  - [x] Implement disabled state styling for invalid actions
- [x] Add feedback display area with tap-to-continue gesture
- [x] Wire up button actions to game logic

## Phase 4: Practice Mode Logic
- [x] Implement random hand generation (uniform distribution)
- [x] Implement random dealer card selection
- [x] Create strategy lookup from loaded JSON data
- [x] Implement correctness checking against strategy
- [x] Retrieve mnemonic/advice from JSON for wrong answers
- [x] Implement tap-to-continue and next hand generation

## Phase 5: Reference Mode
- [x] Create reference tab layout
- [x] Build interactive strategy table from JSON data
  - [x] Hard totals section (player 5-20 vs dealer 2-A)
  - [x] Soft totals section (A,2 through A,9 vs dealer 2-A)
  - [x] Pairs section (2,2 through A,A vs dealer 2-A)
- [x] Color-code cells by action (Hit, Stand, Double, Split)
- [x] Ensure table is scrollable and readable on iPhone screen

## Phase 6: Automated Unit Tests
- [x] Create unit test target in Xcode project
- [x] Card Model Tests
  - [x] Test card creation with valid ranks and suits
  - [x] Test card value calculation (Ace = 11, Face = 10, etc.)
  - [x] Test display value generation
  - [x] Test suit color assignment (red/black)
  - [x] Test SF Symbol mapping
- [x] Hand Model Tests
  - [x] Test hand creation with two cards
  - [x] Test hard total calculation (all Aces as 1)
  - [x] Test soft total calculation (one Ace as 11)
  - [x] Test best total calculation (optimal Ace valuation)
  - [x] Test pair detection
  - [x] Test strategy key generation (hard, soft, pairs)
- [x] Strategy Data Loading Tests
  - [x] Test JSON file loads from bundle
  - [x] Test StrategyData initialization
  - [x] Test all hard totals present (5-20 vs 2-A, 160 entries)
  - [x] Test all soft totals present (A,2-A,9 vs 2-A, 80 entries)
  - [x] Test all pairs present (2,2-A,A vs 2-A, 100 pairs)
  - [x] Verify total entry count (340 entries)
  - [x] Validate all actions are H, S, D, or P
  - [x] Validate all advice strings are non-empty
- [x] Strategy Logic Tests
  - [x] Test getCorrectAction() for hard totals (sample cases)
  - [x] Test getCorrectAction() for soft totals (sample cases)
  - [x] Test getCorrectAction() for pairs (sample cases)
  - [x] Test getAdvice() returns non-empty strings
  - [x] Test dealer card strategy key mapping (face cards → "10", Ace → "A")
- [x] All tests passing with 100% success rate

## Phase 6.5: UI Improvements
- [x] Fix dark mode visibility issue for "Tap to Continue" label [agent: swift-expert]
  - [x] Update text color to use adaptive color (.primary)
  - [x] Update background to use .regularMaterial for adaptive appearance
  - [x] Test visibility in both light and dark modes on physical device

## Phase 7: Manual Testing & Polish
- [x] Configure development team for code signing
- [x] Build and run on iOS Simulator
- [x] Verify app launches successfully
- [x] Basic functionality test (practice and reference modes work)
- [x] Comprehensive testing of all hand combinations
- [x] Verify strategy correctness for edge cases
- [x] Test UI on various iPhone screen sizes (different simulators/devices)
- [x] Fix any bugs discovered
- [x] Code cleanup if needed

## Dependencies
- Phase 2 must complete before Phase 4
- Phase 3 must complete before Phase 4
- Phase 1 must complete before all other phases
- Phase 6 (Unit Tests) can begin after Phases 1-5 complete
- Phase 6.5 (UI Improvements) can begin after Phases 1-5 complete (independent of Phase 6)
- Phase 7 (Manual Testing) should begin after Phases 6 and 6.5 complete

## Milestones
1. **Project Created**: Phase 1 complete ✓
2. **Models Ready**: Phase 2 complete ✓
3. **Practice Mode Working**: Phases 3-4 complete ✓
4. **Reference Mode Working**: Phase 5 complete ✓
5. **Initial Implementation Complete**: Phases 1-5 complete ✓
6. **Unit Tests Complete**: Phase 6 complete ✓
7. **UI Polish Complete**: Phase 6.5 complete ✓
8. **Production Ready**: All phases complete ✓

## Phase 8: Blackjack Re-deal Feature
- [x] Update hand generation logic to detect blackjack (21) [agent: swift-expert]
- [x] Implement re-deal loop until non-blackjack hand is generated [agent: swift-expert]
- [x] Add unit test for blackjack detection [agent: swift-expert]
- [x] Add unit test for re-deal behavior [agent: swift-expert]
- [ ] Manual testing: verify blackjacks are never shown in practice mode

## Current Status
**Phase 8 nearly complete.** Blackjack re-deal feature implemented and tested.
- 82 unit tests passing with 100% success rate (added 4 blackjack tests)
- `Hand.isBlackjack` property added to detect 21 with 2 cards
- `Hand.randomTwoCard()` updated to re-deal on blackjack
- Unit tests verify blackjack detection and re-deal behavior
- Remaining: manual testing to verify no blackjacks appear in practice mode

### Implementation Summary
- 9 Swift source files created
- Complete data models (Card, Hand, GameState, StrategyData)
- Practice mode with random hand generation and feedback
- Reference mode with interactive strategy table
- 340 strategy scenarios in JSON (hard/soft/pairs)
- Development team configured (A75NSTK2G2)
- Successfully runs on iOS Simulator

## Next Steps
### Option 1: Add Unit Tests (Phase 6)
1. Add unit test target to Xcode project
2. Implement automated tests for models and strategy data
3. Achieve 100% test pass rate
4. Provides regression protection for future changes

### Option 2: Fix UI Issues (Phase 6.5)
1. Fix dark mode visibility for "Tap to Continue" label
2. Test on physical device in both light and dark modes
3. Ensures accessibility across appearance modes

### Option 3: Continue Manual Testing (Phase 7)
1. Perform comprehensive testing of all hand combinations
2. Verify strategy correctness for edge cases
3. Test on various iPhone screen sizes
4. Fix any bugs discovered
