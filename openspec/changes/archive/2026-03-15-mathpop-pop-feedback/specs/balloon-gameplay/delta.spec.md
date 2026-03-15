## MODIFIED Requirements

### Requirement: Tap detection and popping

#### Scenario: Correct balloon tapped
- **WHEN** the player taps the balloon containing the correct answer
- **THEN** the balloon plays a popping animation and disappears
- **AND** a particle burst SHALL be triggered at the balloon's position
- **AND** a floating "+10" score popup SHALL appear
- **AND** a subtle screen shake SHALL be applied to the view
- **AND** a new question is generated
