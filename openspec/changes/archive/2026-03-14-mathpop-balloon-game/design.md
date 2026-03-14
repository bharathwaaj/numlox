## Context

The Numlox app currently features traditional screens for learning, but lacks interactive, real-time feedback loops like a fast-paced game. MathPop is the first experimental game added to the Flutter/Dart application aiming to boost engagement for multiplication tables (kids aged 6-10). The gameplay involves balloons rising from the bottom to the top of the screen; players must tap the balloon with the correct answer.

## Goals / Non-Goals

**Goals:**
- Implement a simple and performant game loop utilizing Flutter.
- Provide fluid 2D animations for floating, popping, and shaking balloons.
- Separate the short-term game session state from the long-term application state (until the score is saved after the session).
- Implement a clear "table focus mode" parameter (e.g., locking equations to multiples of 8).

**Non-Goals:**
- Creating a full-fledged physics simulation or using heavy 2D game engines (like Flame).
- Networked multiplayer mode.
- Global leaderboards for now.

## Decisions

### 1. Game Implementation Approach (Flutter Built-ins vs. Game Engine)
- **Decision:** Use Flutter's core framework (`Stack`, `Positioned`, `AnimationController`, standard `Widget`s) instead of integrating Flame or other game engines.
- **Rationale:** The gameplay just involves elements steadily changing Y-coordinates, basic tap detection, and sprite/widget scaling (popping). Integrating an entire game engine is overkill and would complicate screen transitions and app size.

### 2. State Management for the Session
- **Decision:** Use localized state management scoped to the MathPop view (e.g., local stateful widget + providers / Riverpod) containing: `score`, `currentEquation`, `balloonsOnScreen` (with their distinct positions/answers).
- **Rationale:** A game session only lasts 1-3 minutes and doesn't require complex app-wide state tracking until the game concludes.

### 3. Answer Generation Logic
- **Decision:** Create a utility service dedicated to generating 1 correct answer and 3-4 plausible distractors (e.g., if finding `8 x 4 = 32`, distractors could be `24, 40, 28`).
- **Rationale:** True randomness might generate distractors that are too obvious (e.g., `8 x 4 = 999`), reducing the learning value.

## Risks / Trade-offs

- **Risk:** Frame drops or jank on older devices if too many complex widgets and animations appear simultaneously.
  - **Mitigation:** Cap the total number of balloons on screen to around 4-5. Keep animations (popping/shaking) lightweight by using basic scaled transformations rather than heavy physics or particle systems.
- **Risk:** Tap detection inconsistencies due to small target areas.
  - **Mitigation:** Wrap the visual balloon assets in larger padding/hitboxes (`GestureDetector` with `HitTestBehavior.opaque`), making them easy to tap for kids.
- **Risk:** Overlapping balloons occluding answers.
  - **Mitigation:** Assign standard "lanes" or boundaries to starting X coordinates so balloons don't render entirely over one another.
