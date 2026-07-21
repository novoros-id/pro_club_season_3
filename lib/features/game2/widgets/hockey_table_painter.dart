import '../models/game_state.dart';
import 'package:flutter/material.dart';
import '../logic/game2_controller.dart';

class HockeyTablePainter extends CustomPainter {
  final GameState gameState;

  HockeyTablePainter({required this.gameState});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint();

    // 1. Фон стола (Светло-серый, как inputBg в приложении)
    paint.color = const Color(0xFFF2F2F7);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    // 2. Границы стола (Черные, тонкие)
    paint.color = const Color(0xFF121212);
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 4;
    canvas.drawRect(Rect.fromLTWH(2, 2, size.width - 4, size.height - 4), paint);

    // 3. Разметка (Серая, auxText)
    paint.color = const Color(0xFF9B9EA1);
    paint.strokeWidth = 2;

    // Центральная линия
    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      paint,
    );

    // Центральный круг
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      60,
      paint,
    );

    // Точка в центре (Лаймовая)
    paint.style = PaintingStyle.fill;
    paint.color = const Color(0xFFBBF246);
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      6,
      paint,
    );

    // 4. Зоны ворот (Черные прямоугольники)
    paint.style = PaintingStyle.stroke;
    paint.color = const Color(0xFF121212);
    paint.strokeWidth = 3;

    final goalWidth = 120.0;
    final goalDepth = 10.0;

    // Верхние ворота (AI)
    canvas.drawRect(
      Rect.fromLTWH(size.width / 2 - goalWidth / 2, 0, goalWidth, goalDepth),
      paint,
    );

    // Нижние ворота (Игрок)
    canvas.drawRect(
      Rect.fromLTWH(size.width / 2 - goalWidth / 2, size.height - goalDepth, goalWidth, goalDepth),
      paint,
    );

    // Полукруги у ворот (Серые)
    paint.color = const Color(0xFF9B9EA1);
    paint.style = PaintingStyle.stroke;

    // Верхний полукруг
    canvas.drawArc(
      Rect.fromLTWH(size.width / 2 - 100, 20, 200, 100),
      3.14,
      3.14,
      false,
      paint,
    );

    // Нижний полукруг
    canvas.drawArc(
      Rect.fromLTWH(size.width / 2 - 100, size.height - 120, 200, 100),
      0,
      3.14,
      false,
      paint,
    );

    // Круги в углах (Декор)
    final cornerRadius = 40.0;
    final cornerOffset = 80.0;
    paint.style = PaintingStyle.stroke;

    canvas.drawCircle(Offset(cornerOffset, cornerOffset), cornerRadius, paint);
    canvas.drawCircle(Offset(size.width - cornerOffset, cornerOffset), cornerRadius, paint);
    canvas.drawCircle(Offset(cornerOffset, size.height - cornerOffset), cornerRadius, paint);
    canvas.drawCircle(Offset(size.width - cornerOffset, size.height - cornerOffset), cornerRadius, paint);

    // 5. Бита игрока (Черная с Лаймом)
    _drawPaddle(
      canvas,
      gameState.playerPaddlePos,
      const Color(0xFF121212), // Основной цвет
      const Color(0xFFBBF246), // Акцент (кольцо)
    );

    // 6. Бита AI (Серая с Черным)
    _drawPaddle(
      canvas,
      gameState.aiPaddlePos,
      const Color(0xFF9B9EA1), // Основной цвет
      const Color(0xFF121212), // Акцент
    );

    // 7. Шайба (Черная)
    _drawPuck(canvas, gameState.puckPos);
  }

  void _drawPaddle(Canvas canvas, Offset position, Color mainColor, Color accentColor) {
    final Paint paint = Paint();

    // Тень
    paint.color = Colors.black.withOpacity(0.15);
    paint.style = PaintingStyle.fill;
    canvas.drawCircle(
      position + const Offset(3, 3),
      Game2Controller.paddleRadius,
      paint,
    );

    // Основная часть (Черная или Серая)
    paint.color = mainColor;
    canvas.drawCircle(position, Game2Controller.paddleRadius, paint);

    // Внутреннее кольцо (Акцентное)
    paint.color = accentColor;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 4;
    canvas.drawCircle(position, Game2Controller.paddleRadius * 0.7, paint);

    // Ручка/Центр (Белая точка)
    paint.style = PaintingStyle.fill;
    paint.color = Colors.white;
    canvas.drawCircle(position, Game2Controller.paddleRadius * 0.2, paint);
  }

  void _drawPuck(Canvas canvas, Offset position) {
    final Paint paint = Paint();

    // Тень
    paint.color = Colors.black.withOpacity(0.2);
    paint.style = PaintingStyle.fill;
    canvas.drawCircle(
      position + const Offset(2, 2),
      Game2Controller.puckRadius,
      paint,
    );

    // Основная шайба (Черная)
    paint.color = const Color(0xFF121212);
    canvas.drawCircle(position, Game2Controller.puckRadius, paint);

    // Блик (для объема)
    paint.color = Colors.white.withOpacity(0.3);
    canvas.drawCircle(
      position - const Offset(4, 4),
      Game2Controller.puckRadius * 0.3,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant HockeyTablePainter oldDelegate) {
    return oldDelegate.gameState != gameState;
  }
}