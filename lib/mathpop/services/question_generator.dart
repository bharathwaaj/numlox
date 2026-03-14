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
}
