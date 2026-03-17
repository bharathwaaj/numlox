import 'package:flutter/material.dart';
import '../controllers/fishing_game_controller.dart';
import '../models/fish_model.dart';
import '../widgets/fish_widget.dart';
import '../widgets/fisherman_widget.dart';
import '../widgets/hook_widget.dart';
import '../../mathpop/widgets/particle_system.dart';
import '../../mathpop/widgets/score_popup.dart';

class FishingGameScreen extends StatefulWidget {
  const FishingGameScreen({super.key});

  @override
  State<FishingGameScreen> createState() => _FishingGameScreenState();
}

class _FishingGameScreenState extends State<FishingGameScreen>
    with TickerProviderStateMixin {
  final FishingGameController _controller = FishingGameController();
  final List<Widget> _feedbackEffects = [];
  final GlobalKey _gameStackKey = GlobalKey();

  // Casting Animation
  late AnimationController _castController;
  Offset _hookEnd = Offset(200, 400);

  bool _isCasting = false;
  FishModel? _targetFish;

  @override
  void initState() {
    super.initState();
    // Don't start automatically, show menu first

    _castController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _castController.addStatusListener((status) {
      if (!mounted) return; // Guard against unmounted state
      if (status == AnimationStatus.completed) {
        // --- TRIGGER CATCH LOGIC HERE ---
        if (_targetFish != null) {
          final isCorrect = _targetFish!.isCorrect;

          // Trigger logical catch/miss
          _controller.handleTap(_targetFish!);

          // Trigger visual feedback
          _triggerFeedback(_hookEnd, isCorrect);

          if (!isCorrect) {
            // Miss: hook returns quickly
            Future.delayed(const Duration(milliseconds: 200), () {
              if (mounted) _castController.reverse();
            });
            // BUT: we still need to go to next question after the "Learning Moment"
            Future.delayed(const Duration(milliseconds: 2500), () {
              if (mounted) _controller.nextQuestion();
            });
          } else {
            // Catch: linger for a moment then pull up slow
            Future.delayed(const Duration(milliseconds: 500), () {
              if (!mounted) return;
              _castController.duration = const Duration(milliseconds: 1000);
              _castController.reverse().then((_) {
                if (!mounted) return;
                // Reset duration for next cast
                _castController.duration = const Duration(milliseconds: 600);
                // Next question
                _controller.nextQuestion();
              });
            });
          }
        }
      } else if (status == AnimationStatus.dismissed) {
        if (!mounted) return;
        if (_targetFish != null) {
          _targetFish!.isTargeted = false;
        }
        _controller.resetCaughtFish();
        setState(() {
          _isCasting = false;
          _targetFish = null;
        });
      }
    });
  }

  void _triggerFeedback(Offset position, bool isCorrect) {
    if (!mounted) return;

    final particleKey = UniqueKey();
    final scoreKey = UniqueKey();

    setState(() {
      if (isCorrect) {
        _feedbackEffects.add(
          ParticleBurst(
            key: particleKey,
            position: position,
            color: Colors.blueAccent,
          ),
        );
        _feedbackEffects.add(
          ScorePopup(key: scoreKey, position: position, text: "+10"),
        );
      } else {
        _feedbackEffects.add(
          ScorePopup(key: scoreKey, position: position, text: "-5"),
        );
      }
    });

    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        setState(() {
          _feedbackEffects.removeWhere(
            (w) => w.key == particleKey || w.key == scoreKey,
          );
        });
      }
    });
  }

  void _onFishTap(FishModel fish, Offset globalPosition) {
    if (_isCasting || _controller.isTimeout) return;

    final RenderBox stackBox =
        _gameStackKey.currentContext!.findRenderObject() as RenderBox;
    final Offset localPosition = stackBox.globalToLocal(globalPosition);

    setState(() {
      _isCasting = true;
      _targetFish = fish;
      _targetFish!.isTargeted = true;
      _hookEnd = localPosition;
      _controller.setInteracting(true);
      _castController.forward(from: 0.0);
    });
  }

  @override
  void dispose() {
    _castController.stop();
    _castController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        return Scaffold(
          body: LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final height = constraints.maxHeight;
              final waterY = height * 0.35;

              // Local calculation to avoid setting state during build
              final hookStart = Offset(width / 2 + 60, waterY - 50);

              return Stack(
                key: _gameStackKey,
                children: [
                  // 1. SOLID BACKGROUND SPLIT (No leaks)
                  Column(
                    children: [
                      Container(
                        height: waterY,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Color(0xFF81D4FA), Colors.white],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Color(0xFF0277BD), Color(0xFF01579B)],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // 2. WATER SURFACE SHIMMER
                  Positioned(
                    top: waterY - 1,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 3,
                      color: Colors.white.withOpacity(0.3),
                    ),
                  ),

                  // 3. THE FISH (Deep in the water)
                  Positioned(
                    top: waterY + 40,
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Stack(
                      children: _controller.activeFish
                          .where((f) => !f.isCaught)
                          .map(
                            (fish) => FishWidget(
                              key: ValueKey(fish.id),
                              fish: fish,
                              isTimeout: _controller.isTimeout,
                              onTap: (globalPos) => _onFishTap(fish, globalPos),
                            ),
                          )
                          .toList(),
                    ),
                  ),

                  // 4. THE FISHERMAN (Sitting exactly on the line)
                  Positioned(
                    top: waterY - 85,
                    left: 0,
                    right: 0,
                    child: const Center(child: FishermanWidget()),
                  ),

                  // 5. HOOK & LINE
                  if (_isCasting) _buildHookLayer(hookStart),

                  // 6. UI OVERLAYS (Top-most)
                  ..._feedbackEffects,

                  SafeArea(child: _buildHeader()),

                  _buildQuestionArea(),

                  if (_controller.state == FishingGameState.loading)
                    Positioned.fill(child: _buildStartMenu()),

                  if (_controller.state == FishingGameState.gameOver)
                    Positioned.fill(child: _buildGameOver()),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildHookLayer(Offset hookStart) {
    return AnimatedBuilder(
      animation: _castController,
      builder: (context, _) {
        final currentPos = Offset.lerp(
          hookStart,
          _hookEnd,
          _castController.value,
        )!;
        return Stack(
          children: [
            HookWidget(
              start: hookStart,
              end: _hookEnd,
              progress: _castController.value,
            ),
            if (_controller.caughtFish != null)
              Positioned(
                left: currentPos.dx - 50,
                top: currentPos.dy - 30,
                child: IgnorePointer(
                  child: FishWidget(
                    fish: _controller.caughtFish!,
                    onTap: (pos) {},
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildGameOver() {
    return Material(
      color: Colors.black54,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Great Fishing!",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                "Final Score: ${_controller.score}",
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  _controller.startGame(
                    mode: _controller.gameMode,
                    difficulty: _controller.difficulty,
                  );
                },
                child: const Text("Play Again"),
              ),
              TextButton(
                onPressed: () {
                  _controller.resetToMenu();
                },
                child: const Text("Back to Menu"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              ),
              _buildInfoChip(
                Icons.timer,
                "${_controller.timeLeft}s",
                Colors.redAccent,
              ),
              const SizedBox(width: 8),
              _buildInfoChip(
                Icons.hourglass_bottom,
                "${_controller.sessionTime}s",
                Colors.blue,
              ),
            ],
          ),
          _buildInfoChip(
            Icons.stars,
            "Score: ${_controller.score}",
            Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionArea() {
    return Positioned(
      top: 120, // Moved up into the sky area
      left: 0,
      right: 0,
      child: IgnorePointer(
        child: Center(
          child: Text(
            _controller.currentQuestion?.equation ?? "",
            style: const TextStyle(
              fontSize: 64,
              fontWeight: FontWeight.w900,
              color: Color(0xFF01579B), // Darker blue for sky contrast
              shadows: [
                Shadow(
                  color: Colors.white54,
                  offset: Offset(2, 2),
                  blurRadius: 4,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _selectedMode = "addition";
  int _selectedDifficulty = 1;

  Widget _buildStartMenu() {
    return Material(
      color: Colors.black45,
      child: BackdropFilter(
        filter: ColorFilter.mode(Colors.black12, BlendMode.darken),
        child: Center(
          child: Container(
            width: 340,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 20,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Fishing Math",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF01579B),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Pick your challenge!",
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 24),

                // Mode Selection
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Mode",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildModeButton("Add", "addition"),
                    _buildModeButton("Sub", "subtraction"),
                    _buildModeButton("Mixed", "mixed"),
                  ],
                ),

                const SizedBox(height: 24),

                // Difficulty Selection
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Difficulty",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 4),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Easy: 1-2 digit  ·  Medium: 2-3 digit  ·  Hard: 3 digit",
                    style: TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildDifficultyButton("Easy", 1),
                    _buildDifficultyButton("Medium", 2),
                    _buildDifficultyButton("Hard", 3),
                  ],
                ),

                const SizedBox(height: 32),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      _controller.startGame(
                        mode: _selectedMode,
                        difficulty: _selectedDifficulty,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF01579B),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "GO FISHING!",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModeButton(String label, String value) {
    bool isSelected = _selectedMode == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedMode = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF01579B).withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? const Color(0xFF01579B) : Colors.grey.shade300,
            width: 2,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? const Color(0xFF01579B) : Colors.grey.shade700,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildDifficultyButton(String label, int value) {
    bool isSelected = _selectedDifficulty == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedDifficulty = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFFFA000).withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? const Color(0xFFFFA000) : Colors.grey.shade300,
            width: 2,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? const Color(0xFFFFA000) : Colors.grey.shade700,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
