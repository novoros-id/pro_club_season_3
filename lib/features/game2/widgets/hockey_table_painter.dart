import '../models/game_state.dart';
import 'package:flutter/material.dart';
import '../logic/game2_controller.dart';

class HockeyTablePainter extends CustomPainter {
  final GameState gameState;

  HockeyTablePainter({required this.gameState});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint();

    // Фон стола
    paint.color = Colors.lightBlue[50]!;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    // Границы стола
    paint.color = Colors.blue[900]!;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 8;
    canvas.drawRect(Rect.fromLTWH(4, 4, size.width - 8, size.height - 8), paint);

    // Центральная линия
    paint.color = Colors.red[400]!;
    paint.strokeWidth = 3;
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

    // Точка в центре
    paint.style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      8,
      paint,
    );

    // Зоны ворот
    paint.style = PaintingStyle.stroke;
    final goalWidth = 120.0;
    final goalDepth = 10.0;

    // Верхние ворота (AI)
    canvas.drawRect(
      Rect.fromLTWH(
        size.width / 2 - goalWidth / 2,
        0,
        goalWidth,
        goalDepth,
      ),
      paint,
    );

    // Нижние ворота (Игрок)
    canvas.drawRect(
      Rect.fromLTWH(
        size.width / 2 - goalWidth / 2,
        size.height - goalDepth,
        goalWidth,
        goalDepth,
      ),
      paint,
    );

    // Полукруги у ворот
    paint.style = PaintingStyle.stroke;
    // Верхний полукруг
    canvas.drawArc(
      Rect.fromLTWH(
        size.width / 2 - 100,
        20,
        200,
        100,
      ),
      3.14,
      3.14,
      false,
      paint,
    );

    // Нижний полукруг
    canvas.drawArc(
      Rect.fromLTWH(
        size.width / 2 - 100,
        size.height - 120,
        200,
        100,
      ),
      0,
      3.14,
      false,
      paint,
    );

    // Круги в углах
    final cornerRadius = 40.0;
    final cornerOffset = 80.0;

    paint.style = PaintingStyle.stroke;
    // Верхний левый
    canvas.drawCircle(Offset(cornerOffset, cornerOffset), cornerRadius, paint);
    // Верхний правый
    canvas.drawCircle(Offset(size.width - cornerOffset, cornerOffset), cornerRadius, paint);
    // Нижний левый
    canvas.drawCircle(Offset(cornerOffset, size.height - cornerOffset), cornerRadius, paint);
    // Нижний правый
    canvas.drawCircle(Offset(size.width - cornerOffset, size.height - cornerOffset), cornerRadius, paint);

    // Бита игрока (красная)
    _drawPaddle(
      canvas,
      gameState.playerPaddlePos,
      Colors.red[600]!,
      Colors.red[800]!,
    );

    // Бита AI (синяя)
    _drawPaddle(
      canvas,
      gameState.aiPaddlePos,
      Colors.blue[600]!,
      Colors.blue[800]!,
    );

    // Шайба (зеленая/черная)
    _drawPuck(canvas, gameState.puckPos);
  }

  void _drawPaddle(Canvas canvas, Offset position, Color mainColor, Color darkColor) {
    final Paint paint = Paint();

    // Тень
    paint.color = Colors.black26;
    paint.style = PaintingStyle.fill;
    canvas.drawCircle(
      position + const Offset(3, 3),
      Game2Controller.paddleRadius,
      paint,
    );

    // Основная часть
    paint.color = mainColor;
    canvas.drawCircle(position, Game2Controller.paddleRadius, paint);

    // Внутренний круг
    paint.color = darkColor;
    canvas.drawCircle(position, Game2Controller.paddleRadius * 0.6, paint);

    // Ручка
    paint.color = Colors.white;
    canvas.drawCircle(position, Game2Controller.paddleRadius * 0.3, paint);
  }

  void _drawPuck(Canvas canvas, Offset position) {
    final Paint paint = Paint();

    // Тень
    paint.color = Colors.black26;
    paint.style = PaintingStyle.fill;
    canvas.drawCircle(
      position + const Offset(2, 2),
      Game2Controller.puckRadius,
      paint,
    );

    // Основная шайба
    final gradient = RadialGradient(
      colors: [Colors.green[400]!, Colors.green[700]!],
      center: Alignment.topLeft,
    );

    paint.shader = gradient.createShader(
      Rect.fromCircle(center: position, radius: Game2Controller.puckRadius),
    );
    canvas.drawCircle(position, Game2Controller.puckRadius, paint);

    // Блик
    paint.color = Colors.white.withOpacity(0.6);
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