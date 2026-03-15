# mathpop-juiciness Specification

## Purpose
Define common "juicy" feedback elements to enhance the game feel and player satisfaction.

## Requirements

### Requirement: Particle Burst Effect
The system SHALL spawn a burst of particles at a specified screen location.

#### Scenario: Particle burst triggered
- **WHEN** a burst is requested at (x, y)
- **THEN** multiple small colored particles SHALL spawn at the center and radiate outward
- **AND** the particles SHALL fade out after a short duration (e.g., 500ms)

### Requirement: Floating Score Feedback
The system SHALL display temporary floating text indicating score gains.

#### Scenario: Score feedback displayed
- **WHEN** points are earned
- **THEN** a "+10" text widget SHALL appear at the interaction point
- **AND** it SHALL float upwards and fade out simultaneously

### Requirement: Visual Impact (Screen Shake)
The system SHALL apply a brief screen vibration effect to emphasize impact events.

#### Scenario: Screen shake triggered
- **WHEN** an impactful event (like a correct pop) occurs
- **THEN** the entire game viewport SHALL oscillate rapidly by a few pixels for < 200ms
