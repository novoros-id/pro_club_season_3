import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/game_state.dart';
import '../models/game_result.dart';
import '../../../core/services/storage_service.dart';
import 'dart:convert';
import '../../../core/services/audio_service.dart';

final game2ControllerProvider = NotifierProvider<Game2Controller, GameState>(Game2Controller.new);

class Game2Controller extends Notifier<GameState> {
  late final StorageService _storage;
  late final AudioService _audioService;

  // Константы игры
  static const double tableWidth = 400;
  static const double tableHeight = 600;
  static const double paddleRadius = 35;
  static const double puckRadius = 15;

  // 🐢 СКОРОСТЬ: Уменьшаем максимум до 8. Для поля 600px это комфортная скорость.
  static const double maxSpeed = 8.0;
  // Начальная скорость подачи
  static const double serveSpeed = 4.0;
  static const double aiSpeed = 0.09;
  static const int winningScore = 10;

  // Смещение управления (палец ниже биты)
  static const double controlOffsetY = -250.0;

  // Зона "СТОП" для AI. Если шайба ближе этого расстояния, AI замирает по Y.
  static const double aiStopDistance = 90.0;

  @override
  GameState build() {
    _storage = ref.read(storageServiceProvider);
    _audioService = ref.read(audioServiceProvider);
    return GameState.initial();
  }

  void startGame() {
    state = GameState.initial();
    _servePuck();
  }

  void _servePuck() {
    state = state.copyWith(
      puckPos: const Offset(tableWidth / 2, tableHeight / 2),
      puckVelocity: const Offset(0, serveSpeed),
    );
  }

  void updatePlayerPaddle(Offset fingerPosition) {
    final double targetY = fingerPosition.dy + controlOffsetY;
    final x = fingerPosition.dx.clamp(paddleRadius, tableWidth - paddleRadius);
    // Ограничиваем движение биты игрока нижней половиной поля
    final y = targetY.clamp(tableHeight / 2 + paddleRadius, tableHeight - paddleRadius);

    state = state.copyWith(playerPaddlePos: Offset(x, y));
  }

  void updateGame() {
    if (!state.isGameActive || state.isGameOver) return;

    // 1. Движение шайбы
    Offset newPuckPos = state.puckPos + state.puckVelocity;
    Offset newVelocity = state.puckVelocity;

    // --- ГРАНИЦЫ ВОРОТ (должны совпадать с HockeyTablePainter!) ---
    // Ширина ворот 120px, значит от центра (200) влево и вправо по 60px
    final double goalLeft = tableWidth / 2 - 60;
    final double goalRight = tableWidth / 2 + 60;

    // 2. Отскок от боковых стен (левая/правая)
    if (newPuckPos.dx <= puckRadius) {
      newPuckPos = Offset(puckRadius, newPuckPos.dy);
      newVelocity = Offset(-newVelocity.dx * 0.9, newVelocity.dy);
    } else if (newPuckPos.dx >= tableWidth - puckRadius) {
      newPuckPos = Offset(tableWidth - puckRadius, newPuckPos.dy);
      newVelocity = Offset(-newVelocity.dx * 0.9, newVelocity.dy);
    }

    // 3. Отскок от верхней/нижней стен (ЕСЛИ ЭТО НЕ ВОРОТА)
    // Верхняя стена (AI side)
    if (newPuckPos.dy <= puckRadius) {
      // Если шайба НЕ в пределах ворот по X, то она отскакивает от стены
      if (newPuckPos.dx < goalLeft || newPuckPos.dx > goalRight) {
        newPuckPos = Offset(newPuckPos.dx, puckRadius);
        newVelocity = Offset(newVelocity.dx, -newVelocity.dy * 0.9);
      }
      // Иначе (если dx между goalLeft и goalRight) — шайба летит в ворота, ничего не делаем здесь
    }

    // Нижняя стена (Player side)
    if (newPuckPos.dy >= tableHeight - puckRadius) {
      // Если шайба НЕ в пределах ворот по X, то она отскакивает от стены
      if (newPuckPos.dx < goalLeft || newPuckPos.dx > goalRight) {
        newPuckPos = Offset(newPuckPos.dx, tableHeight - puckRadius);
        newVelocity = Offset(newVelocity.dx, -newVelocity.dy * 0.9);
      }
      // Иначе — шайба летит в ворота игрока
    }

    // 4. Движение AI
    final newAiPos = _moveAI(state.aiPaddlePos, state.puckPos, state.puckVelocity);

    // 5. Обработка столкновений с битами
    // Столкновение с игроком
    if (_checkPaddleCollision(newPuckPos, state.playerPaddlePos)) {
      final result = _resolveCollision(newPuckPos, state.playerPaddlePos, newVelocity, true);
      newPuckPos = result.position;
      newVelocity = result.velocity;
    }

    // Столкновение с AI
    if (_checkPaddleCollision(newPuckPos, newAiPos)) {
      final result = _resolveCollision(newPuckPos, newAiPos, newVelocity, false);
      newPuckPos = result.position;
      newVelocity = result.velocity;

      // 🆕 ЗАЩИТА ОТ ЗАЛИПАНИЯ ШАЙБЫ В БИТЕ AI
      final double dist = (newPuckPos - newAiPos).distance;
      if (dist < (paddleRadius + puckRadius + 2.0)) {
        // Телепортируем шайбу чуть выше биты и даем скорость вверх
        newPuckPos = Offset(newPuckPos.dx, newAiPos.dy - (paddleRadius + puckRadius + 5.0));
        newVelocity = Offset(newVelocity.dx, -newVelocity.dy.abs() - 5.0);
      }
    }

    // 6. Проверка гола
    int newPlayerScore = state.playerScore;
    int newAiScore = state.aiScore;
    bool shouldReset = false;

    // ГОЛ В ВОРОТА AI (ВЕРХ)
    // Проверяем: шайба пересекла верхнюю линию И находится внутри ширины ворот
    if (newPuckPos.dy < puckRadius) {
      if (newPuckPos.dx > goalLeft && newPuckPos.dx < goalRight) {
        newPlayerScore++; // Игрок забил
        shouldReset = true;
        _audioService.playGoal(ref);
      }
    }

    // ГОЛ В ВОРОТА ИГРОКА (НИЗ)
    if (newPuckPos.dy > tableHeight - puckRadius) {
      if (newPuckPos.dx > goalLeft && newPuckPos.dx < goalRight) {
        newAiScore++; // AI забил
        shouldReset = true;
        _audioService.playGoal(ref);
      }
    }

    bool isGameOver = newPlayerScore >= winningScore || newAiScore >= winningScore;

    if (shouldReset) {
      if (isGameOver) {
        _saveGameResult(newPlayerScore, newAiScore);
        state = state.copyWith(
          playerScore: newPlayerScore,
          aiScore: newAiScore,
          isGameActive: false,
          isGameOver: true,
        );
      } else {
        // Пауза перед подачей
        state = state.copyWith(
          puckPos: const Offset(tableWidth / 2, tableHeight / 2),
          puckVelocity: const Offset(0, 0),
          playerScore: newPlayerScore,
          aiScore: newAiScore,
          playerPaddlePos: const Offset(tableWidth / 2, tableHeight - 100),
          aiPaddlePos: const Offset(tableWidth / 2, 100),
        );

        Future.delayed(const Duration(milliseconds: 1000), () {
          // Проверяем, что игра все еще активна и счет не изменился пока мы ждали
          if (!state.isGameOver && state.playerScore == newPlayerScore && state.aiScore == newAiScore) {
            _servePuck();
          }
        });
      }
    } else {
      // Ограничение максимальной скорости
      final speed = newVelocity.distance;
      if (speed > maxSpeed) {
        final scale = maxSpeed / speed;
        newVelocity = Offset(newVelocity.dx * scale, newVelocity.dy * scale);
      }

      state = state.copyWith(
        puckPos: newPuckPos,
        puckVelocity: newVelocity,
        aiPaddlePos: newAiPos,
        playerScore: newPlayerScore,
        aiScore: newAiScore,
      );
    }
  }

  // Метод решения коллизий (физика отскока)
  _CollisionResult _resolveCollision(Offset puckPos, Offset paddlePos, Offset velocity, bool isPlayer) {
    final Offset diff = puckPos - paddlePos;
    final double distance = diff.distance;
    if (distance == 0) return _CollisionResult(puckPos, velocity);

    final double overlap = (paddleRadius + puckRadius) - distance;
    if (overlap > 0) {
      final double nx = diff.dx / distance;
      final double ny = diff.dy / distance;

      // Выталкиваем шайбу из биты с запасом
      final double pushOut = overlap + 3.0;
      Offset newPos = Offset(
        puckPos.dx + nx * pushOut,
        puckPos.dy + ny * pushOut,
      );

      // Отражаем скорость
      Offset newVel = _calculateBounceVelocity(newPos, paddlePos, velocity, isPlayer);

      // Принудительный минимальный отскок, чтобы шайба не "прилипала"
      if (newVel.distance < 4.0) {
        final double kickStrength = maxSpeed * 0.8;
        newVel = Offset(nx * kickStrength, ny * kickStrength);
      }

      _audioService.playHit(ref);
      return _CollisionResult(newPos, newVel);
    }
    return _CollisionResult(puckPos, velocity);
  }

  bool _checkPaddleCollision(Offset puckPos, Offset paddlePos) {
    final distance = (puckPos - paddlePos).distance;
    return distance < (paddleRadius + puckRadius);
  }

  Offset _calculateBounceVelocity(Offset puckPos, Offset paddlePos, Offset velocity, bool isPlayer) {
    final normal = (puckPos - paddlePos).normalize();
    final dotProduct = velocity.dx * normal.dx + velocity.dy * normal.dy;
    final reflection = velocity - normal.scale(2 * dotProduct, 2 * dotProduct);

    // Небольшое ускорение при ударе
    final speedBoost = isPlayer ? 1.1 : 1.05;
    return Offset(
      reflection.dx * speedBoost,
      reflection.dy * speedBoost,
    );
  }

  // Логика движения AI
  Offset _moveAI(Offset currentPos, Offset puckPos, Offset puckVelocity) {
    double targetX = puckPos.dx;

    // Лимиты поля для AI (верхняя половина)
    const double minX = paddleRadius;
    const double maxX = tableWidth - paddleRadius;
    const double minY = paddleRadius;
    const double maxY = tableHeight / 2 - paddleRadius - 10;

    // Если шайба летит ОТ нас (к игроку), возвращаемся в центр ворот
    if (puckVelocity.dy > 0) {
      targetX = tableWidth / 2;
      double safeY = tableHeight * 0.2;

      double newX = (currentPos.dx + (targetX - currentPos.dx) * (aiSpeed * 0.5)).clamp(minX, maxX);
      double newY = (currentPos.dy + (safeY - currentPos.dy) * (aiSpeed * 0.5)).clamp(minY, maxY);
      return Offset(newX, newY);
    }

    // Если шайба летит К нам
    final double distanceToPuck = (puckPos - currentPos).distance;

    // 🛑 ГЛАВНОЕ ИСПРАВЛЕНИЕ: Если шайба опасно близко, ЗАМИРАЕМ по Y!
    if (distanceToPuck < aiStopDistance) {
      double newX = (currentPos.dx + (targetX - currentPos.dx) * (aiSpeed * 0.8)).clamp(minX, maxX);
      // Y не меняем (currentPos.dy), тем самым избегая наезда на шайбу
      return Offset(newX, currentPos.dy.clamp(minY, maxY));
    }

    // Если шайба далеко, спокойно занимаем позицию
    double defensiveLine = tableHeight * 0.35;
    double targetY = puckPos.dy < defensiveLine ? puckPos.dy : defensiveLine;

    double newX = (currentPos.dx + (targetX - currentPos.dx) * aiSpeed).clamp(minX, maxX);
    double newY = (currentPos.dy + (targetY - currentPos.dy) * aiSpeed).clamp(minY, maxY);

    return Offset(newX, newY);
  }

  void _saveGameResult(int playerScore, int aiScore) async {
    final result = GameResult(
      playerScore: playerScore,
      aiScore: aiScore,
      date: DateTime.now(),
      isWin: playerScore > aiScore,
    );
    await _storage.setString('game2_last_result', jsonEncode(result.toJson()));
  }

  Future<GameResult?> getLastResult() async {
    final data = await _storage.get<String>('game2_last_result');
    if (data == null) return null;
    try {
      return GameResult.fromJson(jsonDecode(data));
    } catch (e) {
      return null;
    }
  }

  void resetGame() {
    state = GameState.initial();
  }
}

class _CollisionResult {
  final Offset position;
  final Offset velocity;
  _CollisionResult(this.position, this.velocity);
}

extension VectorExtension on Offset {
  Offset normalize() {
    final distance = this.distance;
    if (distance == 0) return const Offset(0, 1);
    return Offset(dx / distance, dy / distance);
  }

  Offset scale(double scaleX, double scaleY) {
    return Offset(dx * scaleX, dy * scaleY);
  }
}