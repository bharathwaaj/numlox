import 'dart:async';
import 'package:flutter/material.dart';
import '../models/balloon_model.dart';
import '../services/question_generator.dart';

class GameController extends ChangeNotifier {
  final QuestionGenerator _questionGenerator = QuestionGenerator();

  // Session Timer
  int _timeLeft = 60;
  int get timeLeft => _timeLeft;
  Timer? _timer;

  bool _isPlaying = false;
  bool get isPlaying => _isPlaying;

  // Score Updates
  int _score = 0;
  int get score => _score;

  // Current Question
  QuestionData? _currentQuestion;
  QuestionData? get currentQuestion => _currentQuestion;
  
  String get currentEquation => _currentQuestion?.equation ?? "";

  // active balloons
  final List<BalloonModel> _activeBalloons = [];
  List<BalloonModel> get activeBalloons => _activeBalloons;
  Timer? _spawnTimer;
  int _balloonIdCounter = 0;

  // Table Focus
  int _tableFocus = 8;
  int get tableFocus => _tableFocus;

  void startGame({int focus = 8}) {
    _tableFocus = focus;
    _score = 0;
    _timeLeft = 60;
    _isPlaying = true;

    _generateQuestion();
    _startSpawning();
    _startTimer();
    notifyListeners();
  }

  void _startSpawning() {
    _spawnTimer?.cancel();
    _spawnTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isPlaying && _activeBalloons.length < 4) {
        _spawnBalloon();
      }
    });
  }

  void _spawnBalloon() {
    if (_currentQuestion == null) return;

    Set<int> usedLanes = _activeBalloons.map((b) => b.laneIndex).toSet();
    List<int> freeLanes = [0, 1, 2, 3].where((l) => !usedLanes.contains(l)).toList();
    if (freeLanes.isEmpty) return;
    freeLanes.shuffle();
    int chosenLane = freeLanes.first;

    Set<int> presentAnswers = _activeBalloons.map((b) => b.answerValue).toSet();
    List<int> unusedOptions = _currentQuestion!.options.where((opt) => !presentAnswers.contains(opt)).toList();
    
    if (unusedOptions.isEmpty) return; // all 4 are on screen
    unusedOptions.shuffle();
    int answerValue = unusedOptions.first;
    bool isCorrect = answerValue == _currentQuestion!.correctAnswer;

    _activeBalloons.add(BalloonModel(
        id: _balloonIdCounter++,
        answerValue: answerValue,
        isCorrect: isCorrect,
        laneIndex: chosenLane,
    ));
    notifyListeners();
  }

  void removeBalloonFallback(int id) {
    _activeBalloons.removeWhere((b) => b.id == id);
    notifyListeners();
  }

  void handleTap(BalloonModel balloon) {
    if (!_isPlaying) return;
    
    if (balloon.isCorrect) {
      increaseScore();
      // Brief delay so pop animation is visible before resetting balloons
      Future.delayed(const Duration(milliseconds: 300), () {
        if (_isPlaying) {
          _generateQuestion();
        }
      });
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        _timeLeft--;
        notifyListeners();
      } else {
        endSession();
      }
    });
  }

  void endSession() {
    _timer?.cancel();
    _spawnTimer?.cancel();
    _isPlaying = false;
    _activeBalloons.clear();
    notifyListeners();
  }

  void increaseScore() {
    _score += 10;
    notifyListeners();
  }

  void _generateQuestion() {
    _activeBalloons.clear(); // 3.4: clear previous
    _currentQuestion = _questionGenerator.generateQuestion(_tableFocus);
    _spawnBalloon();
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _spawnTimer?.cancel();
    super.dispose();
  }
}
