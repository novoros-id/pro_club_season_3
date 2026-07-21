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
        color: const Color(0xFF121212), // Черный фон, как кнопки
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
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
            label: 'ВЫ',
            isActive: playerScore >= aiScore, // Подсветка лидера
          ),

          // Разделитель
          Text(
            ':',
            style: TextStyle(
              fontFamily: 'Unbounded',
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: const Color(0xFFBBF246), // Лаймовое двоеточие
            ),
          ),

          // Счет AI
          _ScoreDisplay(
            score: aiScore,
            label: 'AI',
            isActive: aiScore > playerScore,
          ),
        ],
      ),
    );
  }
}

class _ScoreDisplay extends StatelessWidget {
  final int score;
  final String label;
  final bool isActive;

  const _ScoreDisplay({
    required this.score,
    required this.label,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Lato',
            color: isActive ? const Color(0xFFBBF246) : Colors.white70,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            // Если лидер - лаймовый фон, иначе прозрачный
            color: isActive ? const Color(0xFFBBF246).withOpacity(0.2) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
                color: isActive ? const Color(0xFFBBF246) : Colors.white30,
                width: 1
            ),
          ),
          child: Text(
            score.toString(),
            style: TextStyle(
              fontFamily: 'Unbounded',
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