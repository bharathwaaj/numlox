# Proposal: fishing-math-game

## Context
Numlox provides engaging math practice for children. This change introduces the "Fishing Math Game," a new mini-game designed for children aged 6–10 to improve addition and subtraction skills in a playful, interactive environment.

## Solution
A fishing-themed mini-game where a math question is shown at the top, and players catch the fish carrying the correct answer. The game uses horizontal swim lanes and a casting mechanic to keep learners engaged while they calculate answers.

## What Changes
- New game module under `lib/fishing_math/`.
- Implementation of `FishingGameController` and `FishingGameScreen`.
- New animation systems for fish swimming and rod casting.
- Integration with score and session systems.

## Capabilities

### New Capabilities
- `fishing-gameplay`: Core game loop including horizontal lane fish spawning, tap-to-cast mechanics, and visual feedback for correct/incorrect catches.
- `fishing-math-content`: Progressive math difficulty scaling from addition to subtraction and mixed modes, integrated with the game's timing and fish distribution logic.

### Modified Capabilities
- `question-generation`: Update the question service to support fishing-specific distributions (plausible incorrect answers).

## Impact
- **Architecture**: Follows the `MathPop` patterns (Controller/Service/UI).
- **Navigation**: New entry point in the main menu.
- **State Management**: New game session logic for fishing.
