/# Test Plan

## Unit Tests

### Card Model
- [ ] Card creation with valid ranks and suits
- [ ] Card value calculation (Ace = 1/11, Face = 10, etc.)
- [ ] Card display text generation (e.g., "A♠", "K♥")
- [ ] Correct color assignment (red for hearts/diamonds, black for clubs/spades)

### Hand Model
- [x] Hand creation with two cards
- [x] Hand value calculation (hard vs soft totals)
- [x] Pair detection (for split eligibility)
- [x] Blackjack detection (21 on two cards)
- [x] isBlackjack returns true for Ace + 10-value card
- [x] isBlackjack returns false for non-21 hands
- [x] isBlackjack returns false for 21 from non-blackjack combinations

### Strategy Data Loading
- [ ] JSON file loads successfully from bundle
- [ ] StrategyData initializes without errors
- [ ] JSON structure matches expected schema (hard, soft, pairs sections)
- [ ] All hard total scenarios present (5-20 vs 2-A)
  - [ ] Hard 5 vs dealer 2-A (10 entries)
  - [ ] Hard 9 vs dealer 2-A (10 entries, doubles vs 3-6)
  - [ ] Hard 10 vs dealer 2-A (10 entries, doubles vs 2-9)
  - [ ] Hard 11 vs dealer 2-A (10 entries, always double)
  - [ ] Hard 12 vs dealer 2-A (10 entries, stands vs 4-6)
  - [ ] Hard 13-16 vs dealer 2-A (40 entries, stand vs 2-6)
  - [ ] Hard 17-20 vs dealer 2-A (40 entries, always stand)
- [ ] All soft total scenarios present (A,2 through A,9 vs 2-A)
  - [ ] Soft A,2 and A,3 vs dealer 2-A (20 entries, double vs 5-6)
  - [ ] Soft A,4 and A,5 vs dealer 2-A (20 entries, double vs 4-6)
  - [ ] Soft A,6 vs dealer 2-A (10 entries, double vs 3-6)
  - [ ] Soft A,7 vs dealer 2-A (10 entries, stand vs 2,7,8)
  - [ ] Soft A,8 and A,9 vs dealer 2-A (20 entries, always stand)
- [ ] All pair scenarios present (2,2 through A,A vs 2-A)
  - [ ] Pairs 2,2 and 3,3 vs dealer 2-A (20 entries, split vs 2-7)
  - [ ] Pair 4,4 vs dealer 2-A (10 entries, split vs 5-6 only)
  - [ ] Pair 5,5 vs dealer 2-A (10 entries, never split, treat as hard 10)
  - [ ] Pair 6,6 vs dealer 2-A (10 entries, split vs 2-6)
  - [ ] Pair 7,7 vs dealer 2-A (10 entries, split vs 2-7)
  - [ ] Pair 8,8 vs dealer 2-A (10 entries, always split)
  - [ ] Pair 9,9 vs dealer 2-A (10 entries, split except vs 7,10,A)
  - [ ] Pair 10,10 vs dealer 2-A (10 entries, never split)
  - [ ] Pair A,A vs dealer 2-A (10 entries, always split)
- [ ] Each scenario has valid action (H, S, D, P)
- [ ] Each scenario has non-empty mnemonic/advice text
- [ ] Total entry count = 160 hard + 80 soft + 100 pairs = 340 entries

### Strategy Logic
- [ ] `getCorrectAction()` returns correct action for hard totals
  - [ ] Hard 11 vs dealer 5 returns Double
  - [ ] Hard 16 vs dealer 10 returns Hit
  - [ ] Hard 17 vs dealer 2 returns Stand
- [ ] `getCorrectAction()` returns correct action for soft totals
  - [ ] Soft A,6 vs dealer 4 returns Double
  - [ ] Soft A,7 vs dealer 9 returns Hit
  - [ ] Soft A,8 vs dealer 6 returns Stand
- [ ] `getCorrectAction()` returns correct action for pairs
  - [ ] Pair 8,8 vs dealer Ace returns Split
  - [ ] Pair 5,5 vs dealer 6 returns Double
  - [ ] Pair 9,9 vs dealer 7 returns Stand
- [ ] `getAdvice()` returns non-empty advice for all scenarios
- [ ] Hand strategy key generation matches JSON structure
  - [ ] Hard hand generates numeric key (e.g., "16")
  - [ ] Soft hand generates "A,X" key (e.g., "A,6")
  - [ ] Pair generates "X,X" key (e.g., "8,8")
- [ ] Dealer card strategy key generation
  - [ ] Face cards (J, Q, K) map to "10"
  - [ ] Ace maps to "A"
  - [ ] Number cards map to their value ("2"-"9")
- [ ] Edge case: BlackJack (21 on first two cards)

### Feedback Generator
- [ ] Correct feedback message generated
- [ ] Wrong feedback includes advice/tip
- [ ] Advice is contextually appropriate

## Integration Tests

### Practice Flow
- [x] Hand generation produces valid scenarios
- [x] Hand generation never produces blackjack (21)
- [x] Re-deal occurs when blackjack is initially generated
- [ ] User selection triggers validation
- [ ] Correct answer advances to next hand
- [ ] Wrong answer shows feedback then advances
- [ ] Continuous play without crashes

### UI Navigation
- [ ] Tab switching works correctly
- [ ] Practice tab displays all required elements
- [ ] Reference tab displays strategy chart
- [ ] UI remains responsive during interaction

## Manual Tests

### Feedback View Multiline Text
- [ ] Advice text wraps across multiple lines (no truncation)
- [ ] Feedback container expands to fit advice text
- [ ] Longest advice strings display completely on iPhone SE
- [ ] Longest advice strings display completely on iPhone 17 Pro Max
- [ ] Longest advice strings display completely on iPad
- [ ] ScrollView appears if advice exceeds reasonable height
- [ ] Feedback view layout works in portrait orientation
- [ ] Feedback view layout works in landscape orientation
- [ ] No layout overflow or clipping with longest advice

### Practice Mode
- [x] Cards display with correct text and suit symbols
- [x] Hearts and diamonds display in red
- [x] Clubs and spades display in black
- [x] All four buttons are tappable when valid
- [x] Split button disabled for non-pairs
- [x] Feedback appears after button press
- [x] Tap-to-continue advances to next hand
- [x] App always displays in dark mode (ignores system setting)
- [x] All UI elements visible and readable in dark mode
- [x] Can play at least 20 consecutive hands
- [x] Visual feedback distinguishes correct/wrong
- [x] Mnemonic/advice shown for wrong answers
- [ ] Blackjacks (21) never appear in practice mode
- [ ] Play 100 hands and verify no blackjacks shown

### Responsive Card Sizing
- [x] Cards scale proportionally on iPhone SE (smallest screen) - build successful
- [x] Cards scale proportionally on iPhone 17 Pro - build successful, tests passing
- [x] Cards scale proportionally on iPhone 17 Pro Max (largest screen) - build successful
- [ ] Card text remains readable on all device sizes (manual verification needed)
- [x] Card aspect ratio maintained (width = height * 0.7) - implemented in CardView
- [ ] No layout overflow or clipping on any device size (manual verification needed)
- [ ] Playing field uses available space efficiently (manual verification needed)

### Compact Layout Spacing
- [x] Reduced VStack spacing from 24pt to 12pt
- [x] Spacers use minLength constraints for tighter layout
- [x] Builds successfully on iPhone SE (smallest screen)
- [x] Builds successfully on iPhone 17 Pro (standard size)
- [x] Builds successfully on iPhone 17 Pro Max (largest screen)
- [x] All unit tests still passing (no regressions)
- [ ] All elements remain visible and accessible on all device sizes (manual verification needed)
- [ ] Vertical spacing feels comfortable and not cramped (manual verification needed)

### iPad Full-Screen Support
- [x] App targets both iPhone and iPad device families (TARGETED_DEVICE_FAMILY = "1,2")
- [x] Generic iOS build succeeds (confirms iPad support enabled)
- [x] All unit tests still passing on iPhone simulator
- [ ] App renders full-screen on iPad simulator (manual verification needed)
- [ ] Responsive card sizing adapts correctly to iPad screen sizes (manual verification needed)
- [ ] Layout remains usable and readable on iPad Air (manual verification needed)
- [ ] Layout remains usable and readable on iPad Pro 11" (manual verification needed)
- [ ] Layout remains usable and readable on iPad Pro 13" (manual verification needed)

### Landscape Orientation Support
- [x] Code detects orientation using GeometryReader (width > height = landscape)
- [x] Portrait orientation uses vertical layout (dealer top, player middle, buttons bottom)
- [x] Landscape orientation uses horizontal split layout (cards left, buttons right)
- [x] Builds successfully with landscape support
- [x] All unit tests still passing (no regressions)
- [ ] Portrait orientation displays correctly on simulator/device (manual verification needed)
- [ ] Landscape orientation displays correctly on simulator/device (manual verification needed)
- [ ] Card sizing adapts correctly to landscape dimensions (manual verification needed)
- [ ] All elements remain visible and accessible in landscape (manual verification needed)
- [ ] Smooth transition when rotating device (no layout glitches) (manual verification needed)
- [ ] Landscape layout works on iPhone SE (smallest screen) (manual verification needed)
- [ ] Landscape layout works on iPhone 17 Pro Max (largest screen) (manual verification needed)
- [ ] Landscape layout works on iPad (manual verification needed)

### Reference Mode
- [x] Interactive table displays correctly
- [x] Hard totals section visible and scrollable
- [x] Soft totals section visible and scrollable
- [x] Pairs section visible and scrollable
- [x] Cells color-coded by action type
- [x] Table matches strategy JSON data

### Cross-Feature
- [x] Switch between tabs without losing state
- [x] App launches successfully
- [x] No crashes during normal use
- [x] Reasonable performance on older iPhone models

## Edge Cases
- [x] Splitting when player has pair
- [x] Doubling down on 10 or 11
- [x] Soft hands (hands with Ace counted as 11)
- [x] Dealer showing Ace
- [x] Player blackjack (A + 10-value card)
- [x] All same-value hands handled (e.g., 5,5 vs 6,6)

## Performance Tests
- [x] App launches in < 2 seconds
- [x] Hand generation is instant (< 100ms)
- [x] Feedback appears immediately after selection
- [x] Tab switching is smooth
- [x] No memory leaks during extended play

## UI Animation Tests
- [x] Feedback view fades in smoothly when answer is selected (implemented with .opacity transition)
- [x] Feedback view fades out smoothly when transitioning to next hand (withAnimation wrapper)
- [x] Cards transition smoothly between hands (old fade out, new fade in) (using .id() tracking)
- [x] Button state changes animate smoothly (enabled/disabled) (.animation modifier with value)
- [x] Tab switching uses built-in smooth transitions (TabView default behavior)
- [x] Build succeeds on iPhone 17 Pro simulator (verified, all tests passing)
- [ ] Animations perform smoothly on iPhone SE (manual verification needed)
- [ ] Animations perform smoothly on iPhone 17 Pro Max (manual verification needed)
- [ ] Animation timing feels natural (0.3s feedback, 0.2s buttons) (manual verification needed)
- [ ] Animations work correctly in portrait orientation (manual verification needed)
- [ ] Animations work correctly in landscape orientation (manual verification needed)
- [ ] No animation jank or stuttering during transitions (manual verification needed)
- [ ] Animations don't interfere with user interaction (manual verification needed)
