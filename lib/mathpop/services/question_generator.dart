import 'dart:math';

class QuestionData {
  final String equation;
  final int correctAnswer;
  final List<int> options;

  QuestionData({
    required this.equation,
    required this.correctAnswer,
    required this.options,
  });
}

class QuestionGenerator {
  final Random _random = Random();

  QuestionData generateQuestion(int tableFocus) {
    int x = _random.nextInt(12) + 1; // 1 to 12
    bool focusFirst = _random.nextBool();

    String equation = focusFirst ? "$tableFocus × $x" : "$x × $tableFocus";
    int correctAnswer = tableFocus * x;

    Set<int> distractors = {};

    // Generate plausible distractors based on common mistakes
    List<int> pool = [
      tableFocus * (x > 1 ? x - 1 : x + 2),
      tableFocus * (x < 12 ? x + 1 : x - 2),
      correctAnswer - 1,
      correctAnswer + 1,
      correctAnswer + 2,
      correctAnswer - tableFocus,
      correctAnswer + tableFocus,
    ];

    pool = pool.where((p) => p > 0 && p != correctAnswer).toList();
    pool.shuffle(_random);

    for (int option in pool) {
      if (distractors.length < 3) {
        distractors.add(option);
      }
    }

    // Fallback if we need more options
    while (distractors.length < 3) {
      int r = correctAnswer + _random.nextInt(15) - 7;
      if (r > 0 && r != correctAnswer) {
        distractors.add(r);
      }
    }

    List<int> options = [correctAnswer, ...distractors];
    options.shuffle(_random); // exactly one correct + 3 distractor = 4

    return QuestionData(
      equation: equation,
      correctAnswer: correctAnswer,
      options: options,
    );
  }

  QuestionData generateFishingQuestion({
    required String mode,
    int difficulty = 1, // 1: Easy, 2: Medium, 3: Hard
  }) {
    int a, b, correctAnswer;
    String equation;

    // Determine operand ranges based on difficulty
    // Easy:   1-digit + 1-digit  OR  1-digit + 2-digit
    // Medium: 2-digit + 2-digit  OR  2-digit + 3-digit
    // Hard:   3-digit + 3-digit
    int aMin, aMax, bMin, bMax;

    if (difficulty == 1) {
      aMin = 1;
      aMax = 9;
      final mix2 = _random.nextBool();
      bMin = mix2 ? 10 : 1;
      bMax = mix2 ? 99 : 9;
    } else if (difficulty == 2) {
      aMin = 10;
      aMax = 99;
      final mix3 = _random.nextBool();
      bMin = mix3 ? 100 : 10;
      bMax = mix3 ? 999 : 99;
    } else {
      aMin = 100;
      aMax = 999;
      bMin = 100;
      bMax = 999;
    }

    bool isSubtraction =
        mode == "subtraction" || (mode == "mixed" && _random.nextBool());

    if (isSubtraction) {
      // Ensure a >= b for a positive result
      a = _random.nextInt(aMax - aMin + 1) + aMin;
      int safeBMax = bMax < a ? bMax : a;
      int safeBMin = bMin <= safeBMax ? bMin : 0;
      b = _random.nextInt(safeBMax - safeBMin + 1) + safeBMin;
      correctAnswer = a - b;
      equation = "$a - $b";
    } else {
      a = _random.nextInt(aMax - aMin + 1) + aMin;
      b = _random.nextInt(bMax - bMin + 1) + bMin;
      correctAnswer = a + b;
      equation = "$a + $b";
    }

    Set<int> distractors = {};

    // Distractor pool: off-by-1, 10, 100 to mimic carry/borrow mistakes
    List<int> pool = [
      correctAnswer - 1,
      correctAnswer + 1,
      correctAnswer - 10,
      correctAnswer + 10,
      correctAnswer - 100,
      correctAnswer + 100,
      correctAnswer - 9,
      correctAnswer + 9,
      correctAnswer - 11,
      correctAnswer + 11,
    ];

    pool = pool.where((p) => p >= 0 && p != correctAnswer).toList();
    pool.shuffle(_random);

    for (int option in pool) {
      if (distractors.length < 3) distractors.add(option);
    }

    // Fallback
    while (distractors.length < 3) {
      int range = ((aMax + bMax) * 0.05).toInt().clamp(5, 100);
      int r = correctAnswer + _random.nextInt(range * 2 + 1) - range;
      if (r >= 0 && r != correctAnswer) distractors.add(r);
    }

    List<int> options = [correctAnswer, ...distractors];
    options.shuffle(_random);

    return QuestionData(
      equation: equation,
      correctAnswer: correctAnswer,
      options: options,
    );
  }
}
