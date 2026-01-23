# Open Issues

## Questions Needing Answers

### Landscape Orientation Behavior
- Should layout mirror when rotating between Landscape Left and Landscape Right?
  - Current implementation: Cards always on left, buttons always on right (consistent)
  - Alternative: Cards flip sides based on rotation direction (may be disorienting)
  - Recommendation: Keep current behavior (standard iOS pattern)

### Future Enhancements (Post-MVP)
- Score counter or streak tracker?
- Previous hand review feature?
- Wrong-scenario tracking and practice focus?

## Decisions Pending

### Testing Strategy
- Should unit tests be added before or after comprehensive manual testing?
- What is the minimum acceptable test coverage?

## Notes
- User specified MVP approach, so avoid feature creep
- User is experienced developer, so can handle technical decisions
- Focus on functionality over polish for initial version
