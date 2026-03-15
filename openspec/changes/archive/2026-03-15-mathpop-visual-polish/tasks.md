## 1. Assets & Project Setup

- [x] 1.1 Create `assets/images/mathpop/` directory if it doesn't exist.
- [x] 1.2 Generate/Add `balloon.png` asset to the project.
- [x] 1.3 Add the new image asset to `pubspec.yaml` and run `flutter pub get`.

## 2. Screen & Background Improvements

- [x] 2.1 Update `MathPopGameScreen` background color to a light sky-blue.
- [x] 2.2 Verify layout consistency with the new background.

## 3. Balloon Component Overhaul

- [x] 3.1 Update `BalloonWidget` to use `Image.asset` for the balloon body.
- [x] 3.2 Ensure the answer text is centered and remains readable on top of the image.
- [x] 3.3 Implement the balloon string using `CustomPaint` or an image extension.

## 4. Movement & Animation Refinement

- [x] 4.1 Implement horizontal wobble (oscillation) logic in `BalloonWidget`.
- [x] 4.2 Fine-tune oscillation frequency and amplitude for a natural "floating" feel.
- [x] 4.3 Verify that tap detection remains accurate despite the horizontal movement.
