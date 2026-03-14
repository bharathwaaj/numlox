# balloon-gameplay Specification

## Purpose
TBD - created by archiving change mathpop-balloon-game. Update Purpose after archive.
## Requirements
### Requirement: Spawning balloons
The system SHALL continuously spawn balloons from the bottom of the screen while a question is active.

#### Scenario: Question starts
- **WHEN** a new question is displayed
- **THEN** the system starts spawning balloons containing the correct answer and distractors
- **AND** the balloons move vertically upwards

#### Scenario: Active balloons limit
- **WHEN** spawning balloons
- **THEN** no more than 4-5 balloons exist on screen at a time
- **AND** each lane spawns balloons such that they do not completely overlap

### Requirement: Tap detection and popping
The system SHALL detect taps on balloons and provide visual feedback.

#### Scenario: Correct balloon tapped
- **WHEN** the player taps the balloon containing the correct answer
- **THEN** the balloon plays a popping animation and disappears
- **AND** a new question is generated

#### Scenario: Incorrect balloon tapped
- **WHEN** the player taps a balloon containing a distractor
- **THEN** the balloon plays a shaking/error animation
- **AND** the balloon continues its upward trajectory unpopped

### Requirement: Clear previous balloons
The system SHALL remove balloons from the previous question when a new question begins.

#### Scenario: New question generated
- **WHEN** a correct answer is selected
- **THEN** all balloons from the previous question SHALL be removed
- **AND** new balloons SHALL spawn for the next question

### Requirement: Balloon movement
The system SHALL move balloons vertically upward during gameplay.

#### Scenario: Balloon movement
- **WHEN** a balloon spawns
- **THEN** it SHALL move upward at a constant speed
- **AND** the speed MAY gradually increase as the session progresses

