## ADDED Requirements

### Requirement: Natural Horizontal Swimming
The system SHALL display exactly 4 fish swimming with a natural movement pattern across 4 implicit lanes.

#### Scenario: Fish Movement
- **WHEN** a fish is swimming
- **THEN** it SHALL move horizontally across the screen.
- **AND** it SHALL have a vertical sine-wave bobbing (roaming) to simulate organic movement.

### Requirement: Tap-to-Cast Interaction
The system SHALL allow the player to tap a fish to initiate a fishing hook cast.

#### Scenario: Selection Feedback
- **WHEN** the player taps a fish
- **THEN** the fish SHALL immediately stop swimming and enter a vibration (jiggle) state to await the hook.

#### Scenario: Hook Catch (Correct)
- **WHEN** the player taps a fish with the correct answer
- **THEN** all other fish SHALL vanish while swimming away.
- **AND** the hook SHALL catch the fish and pull it upward to the boat.
- **AND** the score SHALL increase by 10 points.

#### Scenario: Learning Reveal (Incorrect)
- **WHEN** the player taps a fish with an incorrect answer
- **THEN** the selected fish and all other distractors SHALL vanish immediately.
- **AND** the correct fish SHALL glide to the center of the screen, vibrate, and smile (wiggle) to reveal the answer.
- **AND** the score SHALL decrease by 5 points.

### Requirement: Question Timer
The system SHALL enforce a time limit (e.g., 7 seconds) per question.

#### Scenario: Timer Expiration (Global Reveal)
- **WHEN** the timer reaches zero before a selection
- **THEN** all distractors SHALL vanish.
- **AND** the correct fish SHALL glide to the center of the screen and wiggle to reveal the answer.


### Requirement: Question Reset
The system SHALL ensure the game stage is cleared between questions.

#### Scenario: New question
- **WHEN** a question ends (correct, incorrect, or timeout)
- **THEN** all existing fish SHALL be removed.
- **AND** new fish SHALL spawn for the next question.

### Requirement: Score Display
The system SHALL show the player's current score during gameplay.

#### Scenario: Score update
- **WHEN** the score changes
- **THEN** the updated score SHALL be visible on screen immediately.

