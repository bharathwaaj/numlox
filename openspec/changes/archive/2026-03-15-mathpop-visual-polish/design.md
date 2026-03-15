# Design: mathpop-visual-polish

## Context
The MathPop game currently uses basic Flutter `Container` widgets with `BoxShape.circle` to represent balloons. This design documents the transition to a high-fidelity visual experience using image assets, custom animations, and thematic backgrounds.

## Goals / Non-Goals

**Goals:**
- Replace geometric shapes with high-quality balloon image assets.
- Implement a natural "floating" movement pattern with horizontal oscillation.
- Create an immersive sky-themed environment for the game.
- Ensure text remains readable and centered within the new assets.

**Non-Goals:**
- Changing balloon spawn rates or scoring logic.
- Adding sound effects or haptic feedback.
- Introducing multi-colored balloons (deferred to future polish).

## Decisions

### 1. Asset Management
- **Decision**: Use a single high-quality SVG/PNG balloon asset.
- **Rationale**: SVGs provide crisp scaling for different screen sizes. If SVG support is restricted, a high-res PNG will be used.
- **Path**: `assets/images/mathpop/balloon.png`.

### 2. Balloon Rendering (`BalloonWidget`)
- **Decision**: Wrap the balloon image and string in a `Stack`.
- **Components**:
    - `Image.asset`: The main balloon body.
    - `Positioned` Text: The answer value, centered using `Alignment.center`.
    - `CustomPaint`: A simple curved line to represent the balloon string, attached to the bottom anchor of the balloon.

### 3. Wobble Animation Logic
- **Decision**: Use a periodic function (Sine) within the `AnimationController` update loop or a separate `TweenAnimationBuilder`.
- **Implementation**: 
    - `horizontalOffset = sin(currentTime * frequency) * amplitude`.
    - `amplitude` will be set to ~5-10 logical pixels to keep it subtle.

### 4. Sky Background
- **Decision**: Update `MathPopGameScreen` to use a `BoxDecoration` with a light blue color.
- **Color**: `Colors.lightBlue[50]` or a custom `Color(0xFFE3F2FD)`.

## Risks / Trade-offs

- **Risk**: Horizontal wobble might make it slightly harder to tap balloons on smaller screens. 
- **Mitigation**: Keep the oscillation amplitude small and ensure the tap target (`HitTest`) remains consistent or covers the original area.
- **Trade-off**: Adding more complex animations might increase CPU usage on low-end devices, but Flutter's animation engine is efficient enough for this scale.
