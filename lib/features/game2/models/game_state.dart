import 'package:flutter/material.dart';

class GameState {
  final Offset playerPaddlePos;
  final Offset aiPaddlePos;
  final Offset puckPos;
  final Offset puckVelocity;
  final int playerScore;
  final int aiScore;
  final bool isGameActive;
  final bool isGameOver;

  const GameState({
    required this.playerPaddlePos,
    required this.aiPaddlePos,
    required this.puckPos,
    required this.puckVelocity,
    required this.playerScore,
    required this.aiScore,
    this.isGameActive = true,
    this.isGameOver = false,
  });

  GameState copyWith({
    Offset? playerPaddlePos,
    Offset? aiPaddlePos,
    Offset? puckPos,
    Offset? puckVelocity,
    int? playerScore,
    int? aiScore,
    bool? isGameActive,
    bool? isGameOver,
  }) {
    return GameState(
      playerPaddlePos: playerPaddlePos ?? this.playerPaddlePos,
      aiPaddlePos: aiPaddlePos ?? this.aiPaddlePos,
      puckPos: puckPos ?? this.puckPos,
      puckVelocity: puckVelocity ?? this.puckVelocity,
      playerScore: playerScore ?? this.playerScore,
      aiScore: aiScore ?? this.aiScore,
      isGameActive: isGameActive ?? this.isGameActive,
      isGameOver: isGameOver ?? this.isGameOver,
    );
  }

  static GameState initial() {
    return const GameState(
      playerPaddlePos: Offset(200, 500),
      aiPaddlePos: Offset(200, 80),
      puckPos: Offset(200, 300),
      puckVelocity: Offset(0, 0),
      playerScore: 0,
      aiScore: 0,
    );
  }
}