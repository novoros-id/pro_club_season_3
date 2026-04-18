class GameResult {
  final int playerScore;
  final int aiScore;
  final DateTime date;
  final bool isWin;

  const GameResult({
    required this.playerScore,
    required this.aiScore,
    required this.date,
    required this.isWin,
  });

  Map<String, dynamic> toJson() {
    return {
      'playerScore': playerScore,
      'aiScore': aiScore,
      'date': date.toIso8601String(),
      'isWin': isWin,
    };
  }

  factory GameResult.fromJson(Map<String, dynamic> json) {
    return GameResult(
      playerScore: json['playerScore'] ?? 0,
      aiScore: json['aiScore'] ?? 0,
      date: DateTime.parse(json['date']),
      isWin: json['isWin'] ?? false,
    );
  }

  String get resultText {
    if (isWin) return '🏆 Победа!';
    if (playerScore == aiScore) return '🤝 Ничья';
    return '😔 Поражение';
  }
}