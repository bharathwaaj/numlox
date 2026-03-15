# Design: mathpop-pop-feedback

## Context
The MathPop game needs more "juice" to feel engaging. This design covers the implementation of episodic visual effects triggered by player interactions.

## Goals / Non-Goals

**Goals:**
- Implement a particle system for rapid feedback bursts.
- Create an ephemeral "Score Popup" widget.
- Add a screen shake utility to the main game screen.

**Non-Goals:**
- Complex physics for particles (simple linear movement is enough).
- Sound effects.
- Haptic feedback (logic included but actual vibration omitted for now).

## Decisions

### 1. Particle System Implementation
- **Decision**: Use a `CustomPainter` with a list of active particle objects.
- **Rationale**: Efficiently rendering many small circles without the overhead of many widgets.
- **Trigger**: Called via callback in `MathPopGameScreen` when a balloon reports being correctly popped.

### 2. Score Popup Widget
- **Decision**: A simple `StatefulWidget` using `AnimationController` for upward movement and opacity.
- **Style**: Bold yellow or green text with a dark outline for visibility on the sky background.

### 3. Screen Shake Utility
- **Decision**: Wrap the `Stack` in `MathPopGameScreen` with a `Transform.translate` driven by a short duration `AnimationController`.
- **Logic**: Use a `sin` wave with decaying amplitude to shake the screen horizontally/vertically.

### 4. Integration Logic
- **`BalloonWidget`**: Invokes `onTap` which eventually calls the controller. 
- **`MathPopGameScreen`**: Listens for pop events or provides a callback to `BalloonWidget` to trigger locally. To keep logic simple, we'll pass a `onPopFeedback` callback down to the widget.

## Risks / Trade-offs

- **Risk**: Too many particles could cause frame drops.
- **Mitigation**: Limit each burst to 10-15 particles and ensure they dispose of themselves quickly.
- **Trade-off**: Using a simpler `Stack`-based approach for popups instead of a global overlay simplifies state management but requires careful positioning.
