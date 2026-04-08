# Decision Log

2026-01-17 00:00 | SPECIFICATION.md | Strategy variant: most common (dealer stands soft 17, 4-8 decks, no surrender)
2026-01-17 00:00 | SPECIFICATION.md | Invalid actions (Split on non-pair) disabled rather than showing error
2026-01-17 00:00 | SPECIFICATION.md | Card display: text + SF Symbols, red for hearts/diamonds, black for clubs/spades
2026-01-17 00:00 | SPECIFICATION.md | Feedback requires tap to continue (not auto-advance)
2026-01-17 00:00 | SPECIFICATION.md | Wrong answer advice: mnemonic or general principle
2026-01-17 00:00 | SPECIFICATION.md | Hand generation: uniform random distribution
2026-01-17 00:00 | SPECIFICATION.md | Reference mode: interactive table (not static image)
2026-01-17 00:00 | SPECIFICATION.md | Strategy data stored in external JSON file
2026-01-17 00:00 | SPECIFICATION.md | iOS target: latest major stable release (iOS 18+)
2026-01-17 20:26 | TEST_PLAN.md | Added comprehensive unit tests for strategy data loading and validation (hard/soft/pairs)
2026-01-17 20:27 | IMPLEMENTATION_PLAN.md | Added Phase 6 for automated unit tests after initial implementation complete
2026-01-17 20:30 | IMPLEMENTATION_PLAN.md | Marked Phase 7 tasks complete: code signing configured, app tested on simulator
2026-01-17 20:30 | OPEN_ISSUES.md | Resolved implementation questions; moved UI/UX questions to post-MVP
2026-01-18 14:52 | SPECIFICATION.md | "Tap to Continue" label must be visible in both light and dark modes
2026-01-18 14:52 | IMPLEMENTATION_PLAN.md | Added task to fix dark mode visibility issue
2026-01-18 14:52 | TEST_PLAN.md | Added manual tests for light/dark mode visibility
2026-01-18 14:52 | OPEN_ISSUES.md | Documented dark mode visibility bug
2026-01-18 15:00 | IMPLEMENTATION_PLAN.md | Moved dark mode fix to new Phase 6.5 (UI Improvements) between unit tests and manual testing
2026-01-18 18:38 | SPECIFICATION.md | Added blackjack re-deal requirement: auto re-deal if player dealt 21
2026-01-18 18:38 | IMPLEMENTATION_PLAN.md | Added Phase 8 for blackjack re-deal feature implementation
2026-01-18 18:38 | TEST_PLAN.md | Added blackjack detection tests and manual verification tests
2026-01-18 18:52 | IMPLEMENTATION_PLAN.md | Phase 8 tasks completed: blackjack detection and re-deal implemented
2026-01-18 18:52 | TEST_PLAN.md | Blackjack unit tests added and passing (82 total tests)
2026-01-22 10:30 | SPECIFICATION.md | Added responsive card sizing to improve device compatibility
2026-01-22 10:30 | IMPLEMENTATION_PLAN.md | Added Phase 9 for responsive card sizing implementation
2026-01-22 10:30 | TEST_PLAN.md | Added responsive sizing tests for various iPhone sizes
2026-01-22 10:30 | OPEN_ISSUES.md | Removed resolved dark mode visibility bug
2026-01-22 10:45 | SPECIFICATION.md | Added compact layout requirement to reduce vertical spacing
2026-01-22 10:45 | IMPLEMENTATION_PLAN.md | Added Phase 10 for compact layout spacing implementation
2026-01-22 11:00 | SPECIFICATION.md | Changed from iPhone-only to universal app (iPhone and iPad)
2026-01-22 11:00 | IMPLEMENTATION_PLAN.md | Added Phase 11 for iPad full-screen support
2026-01-22 11:00 | TEST_PLAN.md | Added iPad full-screen support tests
2026-01-22 11:15 | SPECIFICATION.md | Added landscape orientation support with adaptive layout
2026-01-22 11:15 | IMPLEMENTATION_PLAN.md | Added Phase 12 for landscape orientation implementation
2026-01-22 11:15 | TEST_PLAN.md | Added landscape orientation tests
2026-01-22 11:30 | SPECIFICATION.md | Increased card height by 50% (15% to 22.5% of screen height, cap 180pt)
2026-01-22 11:30 | PracticeView.swift | Updated cardHeight calculation to 22.5% with 180pt cap
2026-01-22 11:45 | SPECIFICATION.md | Changed to dark mode only (always use dark appearance)
2026-01-22 11:45 | BlackjackStrategyApp.swift | Added .preferredColorScheme(.dark) to force dark mode
2026-01-22 11:50 | SPECIFICATION.md | Added multiline advice text and flexible feedback container requirements
2026-01-22 11:50 | IMPLEMENTATION_PLAN.md | Added Phase 13 for feedback view multiline text improvement
2026-01-22 11:50 | OPEN_ISSUES.md | Added feedback view text truncation bug
2026-01-22 11:50 | TEST_PLAN.md | Added manual tests for feedback view multiline text
2026-01-22 11:55 | OPEN_ISSUES.md | Added bug: feedback view too tall, should be compact
2026-01-22 11:55 | IMPLEMENTATION_PLAN.md | Added Phase 14 to fix feedback view height issue
2026-01-22 12:00 | PracticeView.swift | Removed ScrollView from feedbackView for intrinsic sizing
2026-01-22 12:00 | IMPLEMENTATION_PLAN.md | Phase 14 complete - feedback view now compact
2026-01-22 12:00 | OPEN_ISSUES.md | Removed feedback view height bug (fixed)
2026-01-22 12:05 | SPECIFICATION.md | Added no-border requirement for cards (clean appearance)
2026-01-22 12:05 | IMPLEMENTATION_PLAN.md | Added Phase 15 to remove gray outline from cards
2026-01-22 12:10 | SPECIFICATION.md | Launch screen should use playfield background color (not white)
2026-01-22 12:10 | IMPLEMENTATION_PLAN.md | Added Phase 16 to fix launch screen background color
2026-01-22 12:15 | CardView.swift | Removed gray outline/border from cards
2026-01-22 12:15 | IMPLEMENTATION_PLAN.md | Phase 15 complete - card border removed
2026-01-22 12:15 | Assets.xcassets | Added LaunchBackground color (green opacity 0.15)
2026-01-22 12:15 | BlackjackStrategyApp.swift | Configured launch screen to use LaunchBackground color
2026-01-22 12:15 | IMPLEMENTATION_PLAN.md | Phase 16 complete - launch screen background fixed
2026-01-25 00:00 | SPECIFICATION.md | Added UI animation requirements for smooth transitions
2026-01-25 00:00 | IMPLEMENTATION_PLAN.md | Added Phase 17 for UI animation implementation
2026-01-25 00:00 | TEST_PLAN.md | Added animation tests for feedback, cards, and buttons
2026-01-25 13:36 | PracticeView.swift | Implemented fade-in/fade-out animations for feedback and buttons
2026-01-25 13:36 | PracticeView.swift | Added card transition animations using .id() tracking
2026-01-25 13:36 | GameState.swift | Wrapped state changes in withAnimation() for smooth transitions
2026-01-25 13:36 | Card.swift | Made Card Identifiable to support transition animations
2026-01-25 13:36 | IMPLEMENTATION_PLAN.md | Phase 17 animation implementation complete (manual testing remaining)
2026-01-25 13:40 | GameState.swift | Centralized animation timing with stateTransitionAnimation constant
2026-01-25 13:40 | PracticeView.swift | Simplified by extracting dealerSection, playerSection, stateContent helpers
2026-01-25 13:40 | PracticeView.swift | Removed redundant .transition() modifiers (22 lines saved)
2026-02-28 00:00 | SPECIFICATION.md, IMPLEMENTATION_PLAN.md, TEST_PLAN.md | Add Statistics tab (Tab 3): rolling window of last 1000 plays, overall + per-category + per-hand accuracy, Reset button with confirmation, UserDefaults persistence
2026-02-28 00:01 | SPECIFICATION.md, IMPLEMENTATION_PLAN.md, TEST_PLAN.md | All #Preview blocks must use .preferredColorScheme(.dark) to match app's dark-mode-only appearance
2026-02-28 00:02 | SPECIFICATION.md, IMPLEMENTATION_PLAN.md, TEST_PLAN.md | App icon: Jack of Spades over green felt background matching app colors
2026-04-08 15:30 | SPECIFICATION.md | Added weighted practice mode: bias hand generation toward weak hands using inverse-accuracy formula
2026-04-08 15:30 | SPECIFICATION.md | Added doc comments and animation refactor as technical requirements
2026-04-08 15:30 | IMPLEMENTATION_PLAN.md | Added phases 21 (doc comments), 22 (animation refactor), 23 (weighted practice) — all complete
2026-04-08 15:30 | IMPLEMENTATION_PLAN.md | Updated unit test count to 102, source file count to 12
<!-- LOG_END -->
