# Design: Fishing Math Game

## Context
The "Fishing Math Game" is the second mini-game in the Numlox suite. It follows the "lesson hidden inside" philosophy, where the primary interaction—fishing—serves as the engagement layer for math practice.

## Goals / Non-Goals

**Goals:**
- Create a performant and visually appealing fishing simulation in Flutter.
- Implement a modular game controller that manages spawning, timing, and scoring.
- Provide clear visual and haptic feedback for player actions.
- Reuse existing `QuestionGenerator` infrastructure with fishing-specific extensions.

**Non-Goals:**
- Implementing a persistent underwater world or RPG elements.
- Real-time multiplayer support.
- Advanced physics simulations (using simplified animations instead).

## Decisions

### 1. Module Structure
The game will reside in `lib/fishing_math/` with the following structure:
- `controllers/fishing_game_controller.dart`: Handles game state, timer, and scoring.
- `models/fish.dart`: Data model for fish position, value, and lane.
- `screens/fishing_game_screen.dart`: The main UI layer.
- `widgets/`: `FishWidget`, `FishermanWidget`, `HookWidget`.

### 2. Animation System
- **Fish Movement**: Linear horizontal `AnimationController` per fish, combined with a **vertical sine-wave bobbing (roaming)** to simulate natural swimming.
- **Rod/Hook**: Custom painter for a wooden boat and a fisherman with a rod. The hook trajectory is synced to start from the physical rod tip.
- **Freeze-on-Tap**: Tapped fish immediately stop swimming and enter a high-frequency **vibration (jiggle) state** to provide haptic-visual feedback and ensure accurate hook attachment.
- **Reveal Phase**: A dedicated sequence for incorrect answers or timeouts where:
  - Distractors (wrong answers) **vanish** immediately while swimming away.
  - The correct fish **glides to the screen center**, vibrates, and smiles (wiggles) to provide a "Learning Moment".

### 3. Spawning and Environment
- **Natural Water**: Fish spawn in four implicit lanes across a deep blue water area. Lane dividers are omitted to maintain an organic, premium "underwater" feel.
- **Environment Split**: The background is split into a **Sky area** (top 35%) for UI labels/Equation and a **Water area** (bottom 65%) for gameplay, separated by a shimmering surface line.

### 4. Math Logic Integration
The `FishingGameController` accepts a `mode` (addition/subtraction/mixed) and a `difficulty` (Easy/Medium/Hard) at game start. These are set via a **Start Menu** shown before each session. The `QuestionGenerator` uses operand ranges based on difficulty:
- **Easy**: 1-digit A + (1 or 2-digit) B
- **Medium**: 2-digit A + (2 or 3-digit) B
- **Hard**: 3-digit A + 3-digit B

All subtraction questions guarantee a non-negative result by capping the subtrahend below the minuend.

### 5. Fish Visuals and Personality
To increase engagement, fish will have slight variations:
- **Colors**: Fish will spawn in different colors (e.g., blue, orange, green, yellow).
- **Speeds**: Fish will have slightly randomized swim speeds within a narrow range to make the scene feel dynamic.
- **Direction**: Fish will swim from left-to-right or right-to-left based on their spawn side.


## Risks / Trade-offs

- **Risk**: Overlapping animations between the hook casting and fish movement might cause visual glitches. 
  - *Mitigation*: The "Freeze-on-Tap" mechanic locks the fish's position and triggers a vibration animation, providing a stable target for the hook.
- **Risk**: Backwards swimming during turns.
  - *Mitigation*: Dynamic "Facing" logic determines if a fish should flip its sprite based on its movement vector (especially during the Reveal Phase glide to center).
- **Trade-off**: Using fixed lanes instead of free-swimming fish reduces "realism" but significantly improves readability and hit-box accuracy for children.
