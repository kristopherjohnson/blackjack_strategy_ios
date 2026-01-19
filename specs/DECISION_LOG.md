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
<!-- LOG_END -->
