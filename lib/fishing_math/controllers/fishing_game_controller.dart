import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../models/fish_model.dart';
import '../../mathpop/services/question_generator.dart';

enum FishingGameState { loading, playing, paused, gameOver }

class FishingGameController extends ChangeNotifier {
  final QuestionGenerator _questionGenerator = QuestionGenerator();
  final Random _random = Random();
  bool _disposed = false;

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  FishingGameState _state = FishingGameState.loading;
  FishingGameState get state => _state;

  int _score = 0;
  int get score => _score;

  int _fishIdCounter = 0;

  int _timeLeft = 7;
  int get timeLeft => _timeLeft;

  int _sessionTime = 60;
  int get sessionTime => _sessionTime;

  Timer? _sessionTimer;

  QuestionData? _currentQuestion;
  QuestionData? get currentQuestion => _currentQuestion;

  final List<FishModel> _activeFish = [];
  List<FishModel> get activeFish => _activeFish;

  String _gameMode = "addition"; // Default mode
  String get gameMode => _gameMode;
  int _difficulty = 1; // 1: 1-digit, 2: 2-digit, 3: 3-digit
  int get difficulty => _difficulty;

  bool _isTimeout = false;
  bool get isTimeout => _isTimeout;

  void startGame({String mode = "addition", int difficulty = 1}) {
    _gameMode = mode;
    _difficulty = difficulty;
    _state = FishingGameState.playing;
    _score = 0;
    _isTimeout = false;
    _startSessionTimer();
    _generateQuestion();
    _notify();
  }

  void resetToMenu() {
    _state = FishingGameState.loading;
    _sessionTimer?.cancel();
    _questionTimer?.cancel();
    _caughtFish = null;
    _isInteracting = false;
    _activeFish.clear();
    _notify();
  }

  void _startSessionTimer() {
    _sessionTimer?.cancel();
    _sessionTime = 60;
    _sessionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_disposed) {
        timer.cancel();
        return;
      }
      if (_state == FishingGameState.playing) {
        if (_sessionTime > 0) {
          _sessionTime--;
          _notify();
        } else {
          endGame();
        }
      }
    });
  }

  void nextQuestion() {
    _generateQuestion();
  }

  void _generateQuestion() {
    _isTimeout = false;
    _activeFish.clear();

    _currentQuestion = _questionGenerator.generateFishingQuestion(
      mode: _gameMode,
      difficulty: _difficulty,
    );

    // Distribute 4 options across 4 lanes
    List<int> lanes = [0, 1, 2, 3];
    lanes.shuffle();

    for (int i = 0; i < 4; i++) {
      int answerValue = _currentQuestion!.options[i];
      bool isCorrect = answerValue == _currentQuestion!.correctAnswer;
      int lane = lanes[i];

      _activeFish.add(
        FishModel(
          id: _fishIdCounter++,
          answerValue: answerValue,
          isCorrect: isCorrect,
          laneIndex: lane,
          color: _getRandomColor(),
          speed: 1.5 + _random.nextDouble() * 1.5, // 1.5 to 3.0
          direction: _random.nextBool()
              ? SwimDirection.leftToRight
              : SwimDirection.rightToLeft,
        ),
      );
    }
    _startTimer();
    _notify();
  }

  Color _getRandomColor() {
    List<Color> colors = [
      Colors.blue,
      Colors.orange,
      Colors.green,
      Colors.yellow,
      Colors.red,
      Colors.purple,
    ];
    return colors[_random.nextInt(colors.length)];
  }

  void pauseGame() {
    if (_state == FishingGameState.playing) {
      _state = FishingGameState.paused;
      _notify();
    }
  }

  void resumeGame() {
    if (_state == FishingGameState.paused) {
      _state = FishingGameState.playing;
      _notify();
    }
  }

  void endGame() {
    _state = FishingGameState.gameOver;
    _sessionTimer?.cancel();
    _questionTimer?.cancel();
    _notify();
  }

  FishModel? _caughtFish;
  FishModel? get caughtFish => _caughtFish;

  bool _isInteracting = false;
  bool get isInteracting => _isInteracting;

  void setInteracting(bool value) {
    _isInteracting = value;
    _notify();
  }

  void handleTap(FishModel fish) {
    if (_state != FishingGameState.playing || _caughtFish != null) return;

    _questionTimer?.cancel(); // Turn ends on any selection

    if (fish.isCorrect) {
      fish.isCaught = true;
      _caughtFish = fish;
      updateScore(10);

      // All other fish escape
      for (var f in _activeFish) {
        if (f != fish) f.isEscaping = true;
      }
    } else {
      fish.isShaking = true;
      updateScore(-5);

      // Reveal the correct one, make WRONG ones escape
      for (var f in _activeFish) {
        if (f.isCorrect) {
          f.isRevealing = true;
        } else {
          f.isEscaping = true;
        }
      }
    }
    notifyListeners();
  }

  void resetCaughtFish() {
    _caughtFish = null;
    _isInteracting = false;
    if (_state == FishingGameState.playing && _timeLeft <= 0) {
      _generateQuestion(); // If we timed out while interacting
    }
    _notify();
  }

  Timer? _questionTimer;

  void _startTimer() {
    _questionTimer?.cancel();
    _timeLeft = 7;
    _questionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_disposed) {
        timer.cancel();
        return;
      }
      if (_state == FishingGameState.playing && !_isInteracting) {
        if (_timeLeft > 0) {
          _timeLeft--;
          _notify();
        } else {
          _handleTimeout();
        }
      }
    });
  }

  void _handleTimeout() {
    _questionTimer?.cancel();
    _isTimeout = true;

    // Timeout Reveal: Correct stays and reveals, others escape
    for (var f in _activeFish) {
      if (f.isCorrect) {
        f.isRevealing = true;
      } else {
        f.isEscaping = true;
      }
    }
    _notify();

    // Brief delay before next question to allow learning reveal
    Future.delayed(const Duration(seconds: 3), () {
      if (_disposed) return;
      if (_state == FishingGameState.playing) {
        _generateQuestion();
      }
    });
  }

  void updateScore(int delta) {
    _score += delta;
    _notify();
  }

  @override
  void dispose() {
    _disposed = true;
    _sessionTimer?.cancel();
    _questionTimer?.cancel();
    super.dispose();
  }
}
