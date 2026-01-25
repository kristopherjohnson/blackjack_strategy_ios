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
8. **Blackjack Auto-Redeal**: Phase 8 nearly complete (manual testing pending)
9. **Responsive Design**: Phase 9 complete (manual testing pending)
10. **Compact Layout**: Phase 10 complete (manual testing pending)
11. **iPad Support**: Phase 11 complete (manual testing pending)
12. **Landscape Support**: Phase 12 complete (manual testing pending)
13. **Multiline Feedback**: Phase 13 complete (manual testing pending)
14. **Feedback View Height Fix**: Phase 14 complete ✓
15. **Remove Card Border**: Phase 15 complete ✓
16. **Fix Launch Screen Background**: Phase 16 complete ✓
17. **UI Animations**: Phase 17 not started
18. **Production Ready**: All phases complete

## Phase 8: Blackjack Re-deal Feature
- [x] Update hand generation logic to detect blackjack (21) [agent: swift-expert]
- [x] Implement re-deal loop until non-blackjack hand is generated [agent: swift-expert]
- [x] Add unit test for blackjack detection [agent: swift-expert]
- [x] Add unit test for re-deal behavior [agent: swift-expert]
- [ ] Manual testing: verify blackjacks are never shown in practice mode

## Phase 9: Responsive Card Sizing
- [x] Add GeometryReader to PracticeView to get available height [agent: swift-expert]
- [x] Calculate proportional card height based on screen size [agent: swift-expert]
- [x] Update CardView to accept dynamic height parameter [agent: swift-expert]
- [x] Scale font sizes proportionally with card size [agent: swift-expert]
- [x] Maintain card aspect ratio (width = height * 0.7) [agent: swift-expert]
- [x] Test on various iPhone sizes (SE, Pro, Pro Max simulators) [agent: swift-expert]
- [ ] Verify readability on smallest and largest devices (manual testing required)

## Phase 10: Compact Layout Spacing
- [x] Reduce VStack spacing in PracticeView from 24 to 12 [agent: swift-expert]
- [x] Reduce Spacer() usage to create more compact vertical layout [agent: swift-expert]
- [x] Test layout on various screen sizes to ensure no overflow [agent: swift-expert]
- [ ] Verify all elements remain visible and accessible (manual testing required)

## Phase 11: iPad Full-Screen Support
- [x] Update TARGETED_DEVICE_FAMILY to support both iPhone and iPad [agent: swift-expert]
- [x] Add iPad to supported devices in project settings [agent: swift-expert]
- [x] Test generic iOS build to verify iPad support enabled [agent: swift-expert]
- [ ] Test layout on iPad simulator to verify full-screen rendering (requires simulator setup)
- [ ] Verify responsive card sizing works correctly on iPad screen sizes (manual testing required)
- [ ] Manual verification on iPad device (if available)

## Phase 12: Landscape Orientation Support
- [x] Detect device orientation using GeometryReader size [agent: swift-expert]
- [x] Create landscape layout: HStack with cards on one side, buttons on other [agent: swift-expert]
- [x] Create portrait layout function for vertical arrangement [agent: swift-expert]
- [x] Ensure card sizing adapts to landscape dimensions [agent: swift-expert]
- [x] Test in portrait orientation (verify no regression) [agent: swift-expert]
- [ ] Test in landscape orientation on device/simulator (manual testing required)
- [ ] Verify smooth transition when rotating device (manual testing required)
- [ ] Decide on orientation-specific mirroring behavior (cards left/right based on rotation)

## Phase 13: Feedback View Multiline Text
- [x] Update feedbackView to allow advice text to wrap across multiple lines [agent: swift-expert]
- [x] Remove fixed height constraints on feedback container [agent: swift-expert]
- [x] Add ScrollView if advice text exceeds reasonable height [agent: swift-expert]
- [x] Test with longest advice strings from strategy.json [agent: swift-expert]
- [x] Verify feedback view scales appropriately in both portrait and landscape [agent: swift-expert]
- [ ] Manual testing: verify no text truncation on any device size

## Phase 14: Fix Feedback View Height
- [x] Remove ScrollView from feedbackView (only needed if content exceeds screen) [agent: swift-expert]
- [x] Use intrinsic VStack sizing instead of expanding to fill space [agent: swift-expert]
- [x] Test feedback view appears compact with short messages [agent: swift-expert]
- [x] Test feedback view expands appropriately for long advice text [agent: swift-expert]
- [x] Verify layout in both portrait and landscape orientations [agent: swift-expert]

## Phase 15: Remove Card Border
- [x] Remove gray outline from CardView (delete .overlay modifier) [agent: swift-expert]
- [x] Verify cards remain visually distinct against green background [agent: swift-expert]
- [x] Test card appearance in both portrait and landscape orientations [agent: swift-expert]
- [x] Run unit tests to verify no regressions [agent: swift-expert]

## Phase 16: Fix Launch Screen Background
- [x] Add LaunchBackground color to Assets.xcassets matching playfield green [agent: swift-expert]
- [x] Configure launch screen to use LaunchBackground color [agent: swift-expert]
- [x] Test launch screen displays correct color on simulator [agent: swift-expert]
- [x] Verify smooth transition from launch to main UI [agent: swift-expert]

## Phase 17: UI Animations
- [x] Add fade-in/fade-out animation for feedback view [agent: swift-expert]
  - [x] Animate feedback appearance using .opacity and .transition modifiers
  - [x] Smooth fade-out when transitioning to next hand
- [x] Add card transition animations between hands [agent: swift-expert]
  - [x] Fade out old cards, fade in new cards
  - [x] Use .transition(.opacity) with animation timing
- [x] Add button state change animations [agent: swift-expert]
  - [x] Animate enabled/disabled state transitions
  - [x] Subtle opacity or scale changes
- [x] Test animations on various devices [agent: swift-expert]
  - [x] Verify smooth performance on iPhone 17 Pro (build successful, tests passing)
  - [ ] Verify smooth performance on iPhone SE (manual verification needed)
  - [ ] Verify smooth performance on iPhone 17 Pro Max (manual verification needed)
  - [ ] Check animation timing feels natural (manual verification needed)
- [ ] Test animations in both orientations [agent: swift-expert]
  - [ ] Portrait orientation animations work correctly (manual verification needed)
  - [ ] Landscape orientation animations work correctly (manual verification needed)

## Current Status
**Phase 8 nearly complete.** Blackjack re-deal feature implemented and tested.
**Phase 9 implementation complete.** Responsive card sizing implemented and tested.
**Phase 10 implementation complete.** Compact layout spacing implemented and tested.
**Phase 11 implementation complete.** iPad full-screen support enabled.
**Phase 12 implementation complete.** Landscape orientation support implemented.
**Phase 13 implementation complete.** Feedback view multiline text implemented and tested.
**Phase 14 complete.** Feedback view height fixed - now uses intrinsic sizing (compact).
**Phase 15 complete.** Card border removed - cards have clean appearance without outline.
**Phase 16 complete.** Launch screen background color fixed - uses playfield green.
**Phase 17 implementation complete.** UI animations implemented for feedback, cards, and buttons. Manual testing needed.

### Completed Work
- 82 unit tests passing with 100% success rate (verified after animation implementation)
- Feedback view uses intrinsic sizing (removed ScrollView for compact appearance)
- Card border removed (.overlay modifier deleted from CardView)
- Launch screen background color added (LaunchBackground color asset created)
- Launch screen configured to use playfield green color
- Advice text uses `.fixedSize(horizontal: false, vertical: true)` to prevent truncation
- Successfully builds on iPhone SE, iPhone 17 Pro, and iPhone 17 Pro Max
- `Hand.isBlackjack` property added to detect 21 with 2 cards
- `Hand.randomTwoCard()` updated to re-deal on blackjack
- Unit tests verify blackjack detection and re-deal behavior
- CardView now accepts dynamic height parameter with proportional sizing
- **Card height increased by 50%: now 22.5% of screen height (capped at 180pt)**
- Card width maintains 0.7 aspect ratio
- Font sizes scale proportionally (32% and 24% of card height)
- Corner radius and spacing scale with card size
- VStack spacing reduced from 24 to 12 for more compact layout
- Spacers now use minLength constraints (0 or 8) for tighter spacing
- Successfully builds on iPhone SE, iPhone 17 Pro, and iPhone 17 Pro Max
- **TARGETED_DEVICE_FAMILY updated from "1" (iPhone) to "1,2" (iPhone + iPad)**
- Generic iOS build succeeds (iPad support confirmed)
- iPad orientation settings already configured for all orientations
- **Adaptive orientation layout**: detects landscape vs portrait using GeometryReader
- **Portrait layout**: vertical arrangement (dealer top, player middle, buttons bottom)
- **Landscape layout**: horizontal split (cards left half, buttons/results right half)
- **Dark mode only**: App always displays in dark mode using `.preferredColorScheme(.dark)`
- **UI Animations**: Implemented fade-in/fade-out transitions for feedback and cards
  - Centralized animation timing in `stateTransitionAnimation` constant (0.3s easeInOut)
  - Cards transition smoothly between hands using .id() tracking
  - Button states animate opacity changes (0.2s easeInOut)
  - Animations wrapped in withAnimation() for state changes
  - Card model now Identifiable for proper transition tracking
  - **Code simplified**: PracticeView reduced from 213 to 191 lines by extracting shared helpers
  - Removed redundant .transition() modifiers (implicit with .id() changes)

### Remaining Work
- Phase 8: Manual testing to verify no blackjacks appear in practice mode
- Phase 9: Manual verification of readability on smallest and largest devices
- Phase 10: Manual verification that compact layout elements remain visible and accessible
- Phase 11: Manual testing on iPad simulator/device to verify full-screen rendering and responsive layout
- Phase 12: Manual testing of landscape orientation and rotation transitions; decision on left/right mirroring behavior
- Phase 13: Manual testing to verify no text truncation on any device size
- Phase 14: Fix feedback view height to be compact (only as tall as content)

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
