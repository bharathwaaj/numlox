## ADDED Requirements

### Requirement: Session duration
The system SHALL limit learning sessions to a short duration.

#### Scenario: Timer runs out
- **WHEN** the session is started
- **THEN** a session timer begins countdown (e.g., 60 seconds)
- **AND** when the timer reaches 0, the session ends and the game loop pauses
- **AND** a summary screen is displayed

### Requirement: Scoring system
The system SHALL award points for correct answers and track the score throughout the session.

#### Scenario: Answering correctly
- **WHEN** the user taps the correct balloon
- **THEN** their total score increases by a fixed amount (e.g., +10)
- **AND** the updated score is immediately displayed on the screen

#### Scenario: Answering incorrectly
- **WHEN** the user taps an incorrect balloon
- **THEN** their total score is not modified (no penalty)
- **AND** the current streak is potentially broken if streak tracking is active
