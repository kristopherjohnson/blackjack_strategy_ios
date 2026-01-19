# Blackjack Strategy

An iOS app for memorizing and practicing basic blackjack strategy.

## Features

- **Practice Mode**: Random hands with immediate feedback on correct/incorrect plays
- **Reference Mode**: Interactive strategy charts for hard totals, soft totals, and pairs
- **340 scenarios**: Complete basic strategy coverage with learning advice for each situation

## Requirements

- iOS 18+
- Xcode 16+

## Building

```bash
xcodebuild -project BlackjackStrategy.xcodeproj -scheme BlackjackStrategy \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro' build
```

## Testing

```bash
xcodebuild -project BlackjackStrategy.xcodeproj -scheme BlackjackStrategy \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro' test
```

## Strategy Rules

Based on standard 4-8 deck shoe rules:
- Dealer stands on soft 17
- Double allowed on any two cards
- Split allowed on pairs
- No surrender

## License

MIT License - see [LICENSE](LICENSE)
