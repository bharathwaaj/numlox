# Proposal: mathpop-visual-polish

## Why

The current MathPop UI is a functional prototype using simple shapes and a plain white background. To make it feel like a real children's game, it needs a visual polish pass that introduces proper assets, better animations, and an immersive background. This will improve engagement and make the game feel complete.

## What Changes

- **Balloon UI**: Replace the oval `Container` with a proper balloon image asset.
- **Balloon String**: Add a trailing string to the bottom of the balloons for visual clarity.
- **Wobble Animation**: Introduce a gentle horizontal oscillation (wobble) to balloons as they rise.
- **Immersive Background**: Replace the plain white background with a light sky-blue theme.
- **Answer Presentation**: Render the answer text inside the balloon image.

## Capabilities

### New Capabilities
- `mathpop-visuals`: Covers the implementation of image assets, strings, and background styling.

### Modified Capabilities
- `balloon-gameplay`: Updating movement requirements to include horizontal wobble/oscillation.

## Impact

- `lib/mathpop/widgets/balloon_widget.dart`: Complete redesign of the balloon appearance and addition of wobble animation.
- `lib/mathpop/screens/mathpop_game_screen.dart`: Update to the background styling.
- `assets/images/mathpop/`: New directory for balloon assets.
