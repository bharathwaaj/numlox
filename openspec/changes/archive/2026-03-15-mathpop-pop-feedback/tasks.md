## 1. Components & UI Elements

- [x] 1.1 Implement `ScorePopup` widget with floating animation and fade-out.
- [x] 1.2 Implement `ParticleSystem` widget using `CustomPaint` for optimized burst rendering.

## 2. Feedback Logic & Positioning

- [x] 2.1 Add a callback mechanism in `BalloonWidget` to notify the screen of a pop's global position.
- [x] 2.2 Implement a `PopFeedbackOverlay` in `MathPopGameScreen` to manage active score popups and particle bursts.

## 3. Screen Shake Implementation

- [x] 3.1 Implement a `ScreenShake` wrapper or utility in `MathPopGameScreen`.
- [x] 3.2 Trigger the shake effect whenever a correct balloon is popped.

## 4. Integration & Polish

- [x] 4.1 Connect the tap event in `BalloonWidget` to the new feedback system.
- [x] 4.2 Fine-tune particle colors and velocity for a vibrant look.
- [x] 4.3 Verify that the feedback effects do not block subsequent interactions.
