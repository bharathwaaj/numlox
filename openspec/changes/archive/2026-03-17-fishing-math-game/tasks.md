## 1. Project Setup & Architecture

- [x] 1.1 Create `lib/fishing_math/` directory structure (controllers, models, screens, widgets)
- [x] 1.2 Implement `Fish` model to represent fish state (value, lane, position, color, speed, direction)
- [x] 1.3 Implement `FishingGameController` with state management (loading, playing, paused, game-over)

## 2. Math & Question Logic

- [x] 2.1 Refactor `QuestionGenerator` to support "plausible" incorrect answer generation
- [x] 2.2 Implement question fetching and answer distribution (exactly 1 correct, 3 incorrect)
- [x] 2.3 Implement logic to ensure exactly 4 fish spawn across 4 distinct lanes

## 3. UI & Animation - Fishing Mechanics

- [x] 3.1 Create `FishingGameScreen` with the aquatic background, 4 lanes, and score display
- [x] 3.2 Implement `FishWidget` with horizontal swimming (random direction, color, and speed)
- [x] 3.3 Implement `FishermanWidget` and `HookWidget` with casting animation triggered by a tap
- [x] 3.4 Implement hook-to-fish "locking" logic for catching animations

## 4. Game Loop & Feedback

- [x] 4.1 Implement 5-7 second question timer in `FishingGameController`
- [x] 4.2 Implement "Correct Catch" feedback: Rod bends, fish pulled up, +10 points, success message
- [x] 4.3 Implement "Incorrect Catch" feedback: Fish shakes, splash animation, -5 points
- [x] 4.4 Implement "Timer Expiration" feedback: All fish swim away, correct fish highlights and wiggles
- [x] 4.5 Implement "Question Reset" logic to clear stage and spawn new fish after each turn
- [x] 4.6 Implement session summary screen/popup after game ends

## 5. Integration & Polish

- [x] 5.1 Integrate `FishingGameScreen` into the main app navigation
- [x] 5.2 Perform a visual polish pass (gradients, shadows, micro-animations)
- [x] 5.3 Verify all task requirements against the OpenSpec
- [x] 5.4 Final code cleanup and documentation within the codebase

## 6. Extended Content (Post-MVP)

- [x] 6.1 Implement Start Menu with Mode selection (Addition / Subtraction / Mixed)
- [x] 6.2 Implement Difficulty selection (Easy: 1-2 digit, Medium: 2-3 digit, Hard: 3 digit)
- [x] 6.3 Pass difficulty to `QuestionGenerator` for operand range control
- [x] 6.4 Add "Back to Menu" option on the Game Over screen
- [x] 6.5 Guard all async callbacks (`Future.delayed`, timers) against disposed state to prevent crashes
