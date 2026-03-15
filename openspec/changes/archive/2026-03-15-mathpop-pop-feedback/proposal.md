# Proposal: mathpop-pop-feedback

## Why

Currently, when a balloon is popped correctly, it simply shrinks and disappears. This lack of dynamic feedback makes the game feel less satisfying and lacks the "juice" expected in high-quality children's games. Introducing active feedback like particle bursts and score popups increases the feeling of accomplishment and engagement.

## What Changes

- **Particle Burst**: Add a burst of colorful particles at the location where a balloon is popped.
- **Score Popup**: Display a floating, animated "+10" text at the pop location to visually confirm scoring.
- **Screen Shake**: Implement a subtle, brief camera shake to emphasize the physical impact of the "pop".

## Capabilities

### New Capabilities
- `mathpop-juiciness`: Implementation of particle systems and floating feedback overlays.

### Modified Capabilities
- `balloon-gameplay`: Updating the "Correct balloon tapped" scenario to include visual feedback requirements.

## Impact

- `lib/mathpop/widgets/balloon_widget.dart`: Trigger for feedback effects on tap.
- `lib/mathpop/screens/mathpop_game_screen.dart`: Implementation of screen shake and particle overlay container.
- `lib/mathpop/widgets/particle_system.dart`: New widget for handling episodic particle effects.
- `lib/mathpop/widgets/score_popup.dart`: New widget for floating score animations.
