## 1. Core State and Setup

- [x] 1.1 Create basic module folder structure for MathPop game and routing
- [x] 1.2 Implement local state management (providers/controllers) for game session (score, timer, current question)
- [x] 1.3 Create a GameController responsible for coordinating:
      - question generation
      - balloon spawning
      - score updates
      - session timer

## 2. Question and Answer Generation

- [x] 2.1 Create a utility service to generate multiplication questions based on table focus mode
- [x] 2.2 Implement logic to generate exactly one correct answer and three plausible (unique, positive) distractors
- [x] 2.3 Wire the question generator output into the game state to display the active equation at the top of the screen

## 3. Balloon Movement and Spawning

- [x] 3.0 Create BalloonModel representing:
      - answer value
      - isCorrect flag
      - lane index
      - vertical position
- [x] 3.1 Build the base Balloon widget displaying standard text inside a shape
- [x] 3.2 Implement continuous vertical upward movement using `AnimationController` for balloons
- [x] 3.3 Implement spawning logic restricting balloons to non-overlapping lanes and a maximum of 4-5 active at once
- [x] 3.4 Add capability to clear all previous balloons when a new question begins

## 4. Tap Detection and Feedback

- [x] 4.1 Wrap Balloon widget with tap detection distinguishing correct from incorrect answers
- [x] 4.2 Build popping animation (scaling/fading) for tapping the correct balloon
- [x] 4.3 Build shaking animation for tapping incorrect balloons, allowing them to continue floating
- [x] 4.4 Connect correct taps to trigger score increment and spawn the subsequent question

## 5. Session and Scoring

- [x] 5.1 Implement the 60-second countdown timer that stops the game loop when it reaches 0
- [x] 5.2 Add dynamic real-time scoring display (+10 for correct answers)
- [x] 5.3 Implement the end-of-session summary screen showing the final score
