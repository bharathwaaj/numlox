import 'package:flutter/material.dart';
import 'mathpop/screens/mathpop_game_screen.dart';
import 'fishing_math/screens/fishing_game_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Builder(
            builder: (context) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const MathPopGameScreen(),
                        ),
                      );
                    },
                    child: const Text('Start MathPop'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const FishingGameScreen(),
                        ),
                      );
                    },
                    child: const Text('Start Fishing Math'),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
