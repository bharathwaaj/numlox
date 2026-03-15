import 'package:flutter/material.dart';
import '../controllers/game_controller.dart';
import '../widgets/balloon_widget.dart';
import '../widgets/particle_system.dart';
import '../widgets/score_popup.dart';
import 'dart:math';

class MathPopGameScreen extends StatefulWidget {
  const MathPopGameScreen({super.key});

  @override
  State<MathPopGameScreen> createState() => _MathPopGameScreenState();
}

class _MathPopGameScreenState extends State<MathPopGameScreen>
    with TickerProviderStateMixin {
  final GameController _controller = GameController();

  // Feedback effects
  final List<Widget> _feedbackEffects = [];
  late AnimationController _shakeController;

  @override
  void initState() {
    super.initState();
    _controller.startGame(focus: 8); // Example focus mode 8

    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
  }

  void _triggerFeedback(Offset position) {
    if (!mounted) return;

    setState(() {
      final key = UniqueKey();

      // Add Particle Burst
      _feedbackEffects.add(
        ParticleBurst(
          key: UniqueKey(),
          position: position,
          color: Colors.redAccent,
        ),
      );

      // Add Score Popup
      _feedbackEffects.add(ScorePopup(key: UniqueKey(), position: position));

      // Trigger Screen Shake
      _shakeController.forward(from: 0.0);

      // Auto-remove effects after duration
      Future.delayed(const Duration(milliseconds: 1000), () {
        if (mounted) {
          setState(() {
            _feedbackEffects.removeWhere((w) => w.key == key);
            // Since we added two, this simple approach of UniqueKey on the widget isn't perfect for removeWhere
            // but for this prototype, clearing periodically or just managing them in a safer way is better.
            // Let's just clear the whole list if it grows too large or use a better tracking mechanism.
            if (_feedbackEffects.length > 20) _feedbackEffects.clear();
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        // Summary Screen
        if (!_controller.isPlaying && _controller.timeLeft <= 0) {
          return Scaffold(
            appBar: AppBar(title: const Text('Game Over')),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Session Complete!',
                    style: TextStyle(fontSize: 32),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Final Score: ${_controller.score}',
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Main Menu',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      _controller.startGame(focus: 8);
                    },
                    child: const Text(
                      'Play Again',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // Active Game Screen
        return Scaffold(
          backgroundColor: Colors.lightBlue[50],
          appBar: AppBar(
            title: Text('MathPop - Table ${_controller.tableFocus}'),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Center(
                  child: Text(
                    'Time: ${_controller.timeLeft}s',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Center(
                  child: Text(
                    'Score: ${_controller.score}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: AnimatedBuilder(
            animation: _shakeController,
            builder: (context, child) {
              final double shake =
                  sin(_shakeController.value * pi * 8) *
                  4 *
                  (1.0 - _shakeController.value);
              return Transform.translate(
                offset: Offset(shake, shake),
                child: child,
              );
            },
            child: Stack(
              children: [
                // Current Equation at Top
                Positioned(
                  top: 40,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text(
                      _controller.currentEquation,
                      style: const TextStyle(
                        fontSize: 56,
                        fontWeight: FontWeight.w900,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
                // Render Balloons
                ..._controller.activeBalloons.map((balloon) {
                  return BalloonWidget(
                    key: ValueKey(balloon.id),
                    balloon: balloon,
                    onPopped: () {
                      _controller.removeBalloonFallback(balloon.id);
                    },
                    onTap: () {
                      _controller.handleTap(balloon);
                    },
                    onPop: (pos) {
                      _triggerFeedback(pos);
                    },
                  );
                }),
                // Feedback Overlay (Particles and Popups)
                ..._feedbackEffects,
              ],
            ),
          ),
        );
      },
    );
  }
}
