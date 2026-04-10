# Open Issues

## Questions Needing Answers

### Landscape Orientation Behavior
- Should layout mirror when rotating between Landscape Left and Landscape Right?
  - Current implementation: Cards always on left, buttons always on right (consistent)
  - Alternative: Cards flip sides based on rotation direction (may be disorienting)
  - Recommendation: Keep current behavior (standard iOS pattern)

### Future Enhancements (Post-MVP)
- Score counter or streak tracker?
- Wrong-scenario tracking and practice focus?

## Decisions Pending

(none)

## Notes
- User specified MVP approach, so avoid feature creep
- User is experienced developer, so can handle technical decisions
- Focus on functionality over polish for initial version
- Weighted practice mode uses hand-key-level weighting only; dealer card weighting is a possible future enhancement (would require adding dealerKey to PlayResult)
