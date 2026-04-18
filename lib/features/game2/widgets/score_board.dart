import 'package:flutter/material.dart';

class ScoreBoard extends StatelessWidget {
  final int playerScore;
  final int aiScore;
  final int winningScore;

  const ScoreBoard({
    super.key,
    required this.playerScore,
    required this.aiScore,
    required this.winningScore,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.blue[900],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Счет игрока
          _ScoreDisplay(
            score: playerScore,
            label: 'Вы',
            color: Colors.red,
          ),

          // Разделитель
          Text(
            ':',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          // Счет AI
          _ScoreDisplay(
            score: aiScore,
            label: 'Компьютер',
            color: Colors.blue,
          ),
        ],
      ),
    );
  }
}

class _ScoreDisplay extends StatelessWidget {
  final int score;
  final String label;
  final Color color;

  const _ScoreDisplay({
    required this.score,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.3),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color, width: 2),
          ),
          child: Text(
            score.toString(),
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}