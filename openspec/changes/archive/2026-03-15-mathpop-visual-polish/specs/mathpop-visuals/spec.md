# mathpop-visuals Specification

## Purpose
Define the visual elements and assets for the MathPop game to provide a polished, child-friendly experience.

## Requirements

### Requirement: Balloon Visual Representation
The system SHALL represent each balloon using a dedicated image asset instead of a basic geometric shape.

#### Scenario: Balloon spawns
- **WHEN** a balloon is rendered on screen
- **THEN** it SHALL use the defined balloon image asset
- **AND** the answer text SHALL be centered within the balloon's body

### Requirement: Balloon String
The system SHALL render a visual string extending from the bottom of each balloon.

#### Scenario: Balloon moving
- **WHEN** a balloon moves upward
- **THEN** a visual string SHALL be visible trailing below it
- **AND** the string SHALL move in sync with the balloon

### Requirement: Game Background
The system SHALL use a thematic background that resembles a sky.

#### Scenario: Game screen loaded
- **WHEN** the MathPop game screen is displayed
- **THEN** the background SHALL be a light sky-color (e.g., light blue)
