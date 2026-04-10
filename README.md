# Blackjack Strategy

An iOS app for memorizing and practicing basic blackjack strategy.

## Features

- **Practice Mode**: Random hands with immediate feedback on correct/incorrect plays; Random or Weighted hand generation (weighted biases toward hands you get wrong)
- **Reference Mode**: Interactive strategy charts for hard totals, soft totals, and pairs
- **Statistics Mode**: Rolling accuracy over the last 1000 plays, broken down overall, by category, and by specific hand
- **Hand Review**: Review recent practice plays (default: incorrect only) to see what you played vs. the correct action and strategy advice
- **340 scenarios**: Complete basic strategy coverage with learning advice for each situation
- **Consistent action colors**: Hit (green), Stand (red), Double (orange), Split (blue) across Practice and Reference screens

## Requirements

- iOS 26+
- Xcode 26+

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
