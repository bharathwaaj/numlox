## ADDED Requirements

### Requirement: Progressive Math Modes
The system SHALL support multiple math operation modes.

#### Scenario: Mode Selection
- **WHEN** the game starts
- **THEN** the player SHALL be able to select "Addition", "Subtraction", or "Mixed" mode from a Start Menu before gameplay begins.

### Requirement: Difficulty Levels
The system SHALL support three difficulty levels that control the operand size of generated questions.

#### Scenario: Easy
- **WHEN** difficulty is set to "Easy"
- **THEN** questions SHALL use 1-digit + 1-digit OR 1-digit + 2-digit operands (e.g. `7 + 4`, `6 + 43`).

#### Scenario: Medium
- **WHEN** difficulty is set to "Medium"
- **THEN** questions SHALL use 2-digit + 2-digit OR 2-digit + 3-digit operands (e.g. `34 + 57`, `23 + 148`).

#### Scenario: Hard
- **WHEN** difficulty is set to "Hard"
- **THEN** questions SHALL use 3-digit + 3-digit operands (e.g. `456 + 237`).

### Requirement: Plausible Distractors
The system SHALL generate distractors that mimic common arithmetic mistakes.

#### Scenario: Distractor Selection
- **WHEN** answers are distributed to fish
- **THEN** exactly one fish SHALL contain the correct answer.
- **AND** the three distractor answers SHALL be off-by-1, off-by-10, or off-by-100 to simulate carry/borrow errors.

### Requirement: Subtraction Safety
The system SHALL ensure subtraction questions always yield a non-negative result.

#### Scenario: Subtraction Constraint
- **WHEN** a subtraction question is generated
- **THEN** the first operand SHALL always be greater than or equal to the second.