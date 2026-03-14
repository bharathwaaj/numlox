import 'package:flutter/material.dart';
import '../controllers/game_controller.dart';
import '../widgets/balloon_widget.dart';

class MathPopGameScreen extends StatefulWidget {
  const MathPopGameScreen({super.key});

  @override
  State<MathPopGameScreen> createState() => _MathPopGameScreenState();
}

class _MathPopGameScreenState extends State<MathPopGameScreen> {
  final GameController _controller = GameController();

  @override
  void initState() {
    super.initState();
    _controller.startGame(focus: 8); // Example focus mode 8
  }

  @override
  void dispose() {
    _controller.dispose();
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
                   const Text('Session Complete!', style: TextStyle(fontSize: 32)),
                   const SizedBox(height: 10),
                   Text('Final Score: ${_controller.score}', style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.blue)),
                   const SizedBox(height: 30),
                   ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      ),
                      onPressed: () {
                         Navigator.of(context).pop();
                      },
                      child: const Text('Main Menu', style: TextStyle(fontSize: 20))
                   ),
                   const SizedBox(height: 10),
                   TextButton(
                      onPressed: () {
                        _controller.startGame(focus: 8);
                      },
                      child: const Text('Play Again', style: TextStyle(fontSize: 20))
                   )
                 ]
               )
             )
          );
        }

        // Active Game Screen
        return Scaffold(
          appBar: AppBar(
            title: Text('MathPop - Table ${_controller.tableFocus}'),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Center(
                  child: Text(
                    'Time: ${_controller.timeLeft}s',
                    style: const TextStyle(fontSize: 16, color: Colors.redAccent, fontWeight: FontWeight.bold),
                  )
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Center(
                  child: Text(
                    'Score: ${_controller.score}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  )
                ),
              ),
            ],
          ),
          body: Stack(
            children: [
              // Current Equation at Top
              Positioned(
                top: 40,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    _controller.currentEquation,
                    style: const TextStyle(fontSize: 56, fontWeight: FontWeight.w900, color: Colors.black87),
                  )
                )
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
                  }
                );
              }),
            ],
          ),
        );
      }
    );
  }
}
