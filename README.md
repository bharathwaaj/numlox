# 🎮 Numlox

> **Math made magical.** A child-first, game-first Flutter app that makes practicing arithmetic genuinely fun.

Numlox is a growing suite of interactive math mini-games designed for children aged 5–10. Each game wraps grade-appropriate math inside a rich, animated experience — so learning happens without kids even realising it.

---

## 🕹️ Games

### 🎈 MathPop — Pop The Right Balloon!
Colorful balloons float upward carrying math answers. Tap the correct one before it escapes the screen.

**Features:**
- Multiplication table practice (all tables, 1–12)
- Plausible distractors to encourage mental math — not guessing
- Particle burst 💥 and floating score popup on correct answers
- Screen shake on misses to keep kids alert
- 60-second session timer with game-over summary

---

### 🎣 Fishing Math — Cast, Catch & Learn!
A fisherman sits in a wooden boat on a beautiful animated lake. Fish swim below, each carrying an answer. Tap one to cast your hook!

**Features:**

#### 🎯 Math Modes
| Mode | Description |
|---|---|
| **Addition** | Pure addition practice |
| **Subtraction** | Borrowing and place-value focus |
| **Mixed** | Random blend of both |

#### 📊 Difficulty Levels
| Level | Operand Sizes | Example |
|---|---|---|
| **Easy** | 1-digit + 1-digit or 2-digit | `7 + 4`, `6 + 43` |
| **Medium** | 2-digit + 2-digit or 3-digit | `34 + 57`, `23 + 148` |
| **Hard** | 3-digit + 3-digit | `456 + 237` |

#### 🐟 Smart Fish Mechanics
- Fish **roam naturally** with horizontal swimming + sine-wave vertical bobbing
- Tap a fish → it immediately **freezes and vibrates** so the hook can catch it cleanly
- **Correct catch** → hook drags the fish up to the boat 🎣
- **Wrong tap** → distractors vanish, the **correct fish glides to the center** and wiggles to reveal the right answer (Learning Moment ✨)
- **Timer runs out** → same Learning Moment triggered automatically — no question skipped without teaching

#### 🚣 Atmosphere
- Sky/Water split scene with a shimmering surface line
- Fisherman painted on a textured wooden boat using `CustomPainter`
- Hook line animates from the physical **rod tip**
- No lane dividers — fish roam freely in open water

---

## 🏗️ Architecture

Numlox follows a clean, modular architecture shared across mini-games:

```
lib/
├── main.dart                    # App entry + game selection menu
│
├── mathpop/                     # 🎈 MathPop Game
│   ├── controllers/             # Game state (score, timer, spawning)
│   ├── models/                  # BalloonModel
│   ├── screens/                 # MathPopGameScreen
│   ├── services/                # QuestionGenerator
│   └── widgets/                 # BalloonWidget, ParticleSystem, ScorePopup
│
└── fishing_math/                # 🎣 Fishing Math Game
    ├── controllers/             # FishingGameController (modes, difficulty, timers)
    ├── models/                  # FishModel (position, state flags)
    ├── screens/                 # FishingGameScreen (layout, HUD, Start Menu)
    └── widgets/                 # FishWidget, FishermanWidget, HookWidget
```

**Design Patterns:**
- `ChangeNotifier`-based controllers for reactive UI updates
- `AnimationController` per fish for independent, natural movement
- All `Future.delayed` and `Timer` callbacks are lifecycle-safe (guarded with `mounted` and a `_disposed` flag)

---

## 📐 OpenSpec

Numlox uses [OpenSpec](https://openspec.dev) for structured feature development. Each capability is formally specified:

| Capability | Description |
|---|---|
| `balloon-gameplay` | Core balloon game loop |
| `fishing-gameplay` | Fishing hook mechanics, Learning Reveal phase |
| `fishing-math-content` | Difficulty levels, mode selection, subtraction safety |
| `question-generation` | Distractor generation for multiplication & addition/subtraction |
| `mathpop-juiciness` | Visual feedback (particles, score popups, shake) |
| `scoring-and-sessions` | Score tracking, session timers, game-over screen |

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK `>=3.0`
- Dart `>=3.0`
- Android / iOS device or emulator

### Run
```bash
flutter pub get
flutter run
```

### Build (Android)
```bash
flutter build apk --release
```

---

## 🎨 Tech & Design Choices

| Concern | Approach |
|---|---|
| UI Framework | Flutter (Material 3) |
| Animations | `AnimationController` + `CustomPainter` |
| State Management | `ChangeNotifier` + `ListenableBuilder` |
| Math Generation | Pure Dart — no external dependencies |
| Visual Style | Gradients, glassmorphism, particle effects |

---

## 📅 Changelog

### v0.2.0 — Fishing Math Game
- Full fishing game with natural fish movement and Learning Reveal phase
- Easy / Medium / Hard difficulty with 1–3 digit operand pairs
- Addition, Subtraction, Mixed modes
- Premium fisherman + boat scene with `CustomPainter`
- Crash-safe async lifecycle management

### v0.1.0 — MathPop
- Balloon popping game for multiplication tables
- Particle burst, score popup, and screen shake feedback
- 60-second timed sessions

---

## 📄 License

MIT © Numlox
