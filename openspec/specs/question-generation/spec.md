# question-generation Specification

## Purpose
TBD - created by archiving change mathpop-balloon-game. Update Purpose after archive.
## Requirements
### Requirement: Generate multiplication equations
The system SHALL generate multiplication questions based on the active table focus.

#### Scenario: Table focus mode active
- **WHEN** the game starts with focus mode "8"
- **THEN** the system generates questions uniquely in the format `8 × Y` or `X × 8`
- **AND** X, Y are integers from 1 to 12

### Requirement: Generate plausible distractors
The system SHALL generate 3 plausible incorrect answers (distractors) alongside the correct answer.

#### Scenario: Displaying options (Multiplication)
- **WHEN** the equation is generated (e.g., `8 × 4`)
- **THEN** the system generates the correct answer `32`
- **AND** the system generates 3 incorrect answers that are close to the correct answer or are common mistakes (e.g., `24`, `40`, `28`)
- **AND** the distractors MUST be positive integers between 1 and 144
- **AND** there MUST NOT be duplicate answers among the 4 options

#### Scenario: Displaying options (Addition/Subtraction – Fishing Math)
- **WHEN** a fishing math question is generated (e.g., `34 + 57`)
- **THEN** the system generates 3 distractors offset by ±1, ±10, or ±100 from the correct answer
- **AND** distractors MUST mimic common carry/borrow mistakes (e.g., off-by-one in tens or hundreds place)
- **AND** there MUST NOT be duplicate answers among the 4 options


### Requirement: Exactly one correct answer

The system SHALL ensure exactly one correct answer exists for each question.

#### Scenario: Generating answer set
- **WHEN** the system generates the correct answer and distractors
- **THEN** exactly one answer SHALL equal the correct multiplication result
- **AND** the other answers SHALL be incorrect

