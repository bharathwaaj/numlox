## Why

My child is currently learning multiplication tables and struggles to memorize them through traditional repetition. Math learning often feels like studying, which can deter engagement. We are building MathPop, a balloon popping game, to make practicing multiplication tables fast-paced and fun, allowing kids (aged 6-10) to learn through repetition without feeling like they are doing traditional math homework. 

## What Changes

We are introducing the first game into the Numlox app, targeting children aged 6-10. The game will feature:
- Multiplication equations displayed at the top of the screen.
- Floating balloons containing plausible answers moving upwards from the bottom.
- Interactive tap mechanics to select the correct answers.
- Visual feedback (animations) and scoring systems.
- Short game sessions (1-3 minutes) with options to focus on specific multiplication tables.

## Capabilities

### New Capabilities

- `question-generation`: Generates multiplication questions and realistic multiple-choice answers, with a specific focus on "table focus mode" (e.g., practicing only the 8 table).
- `balloon-gameplay`: Handles the balloon spawning system, tap detection mechanisms, and simple animations (popping for correct answers, shaking/error state for incorrect taps).
- `scoring-and-sessions`: Manages the scoring system (awarding points for correct taps) and handles the short 1-3 minute session lifecycle.

### Modified Capabilities

None at this time.

## Impact

- Adds the first interactive game engine/components to the Flutter/Dart application.
- Introduces state management specifically for fast-paced gameplay.
- Expands the core learning loop to include interactive media alongside traditional app views.
