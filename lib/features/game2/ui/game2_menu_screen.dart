import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../logic/game2_controller.dart';
import '../models/game_result.dart';

class Game2MenuScreen extends ConsumerStatefulWidget {
  const Game2MenuScreen({super.key});

  @override
  ConsumerState<Game2MenuScreen> createState() => _Game2MenuScreenState();
}

class _Game2MenuScreenState extends ConsumerState<Game2MenuScreen> {
  GameResult? _lastResult;
  bool _isLoading = true;

  // 🎨 Дизайн-система
  static const Color primaryText = Color(0xFF121212);
  static const Color accentColor = Color(0xFFBBF246);
  static const Color auxText = Color(0xFF9B9EA1);
  static const Color bgLight = Color(0xFFF2F2F7);

  @override
  void initState() {
    super.initState();
    _loadLastResult();
  }

  Future<void> _loadLastResult() async {
    final result = await ref.read(game2ControllerProvider.notifier).getLastResult();
    if (mounted) {
      setState(() {
        _lastResult = result;
        _isLoading = false;
      });
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes} мин. назад';
      }
      return '${difference.inHours} ч. назад';
    } else if (difference.inDays == 1) {
      return 'Вчера';
    } else {
      return DateFormat('dd.MM.yyyy').format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // ✅ Белый фон
      appBar: AppBar(
        title: const Text(
          'АЭРОХОККЕЙ',
          style: TextStyle(
            fontFamily: 'Unbounded',
            fontWeight: FontWeight.bold,
            color: primaryText,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: primaryText,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              // Иконка
              Icon(
                Icons.sports_hockey,
                size: 80,
                color: primaryText, // Черная иконка
              ),
              const SizedBox(height: 16),
              Text(
                'Давай сыграем!',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontFamily: 'Unbounded',
                  fontWeight: FontWeight.bold,
                  color: primaryText,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Забей 10 голов первым и победи компьютер!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Lato',
                  fontSize: 16,
                  color: auxText,
                ),
              ),
              const SizedBox(height: 40),

              // Кнопка Играть
              ElevatedButton(
                onPressed: () => context.push('/game2/play'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryText, // Черная кнопка
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  elevation: 0,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.play_arrow, size: 28),
                    SizedBox(width: 12),
                    Text(
                      'ИГРАТЬ',
                      style: TextStyle(
                        fontFamily: 'Unbounded',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Последняя игра
              if (_isLoading)
                const Center(child: CircularProgressIndicator(color: accentColor))
              else if (_lastResult != null)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: bgLight, // Светло-серый фон карточки
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: accentColor.withOpacity(0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.history,
                            color: primaryText,
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Последняя игра',
                            style: TextStyle(
                              fontFamily: 'Unbounded',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: primaryText,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          // Счет
                          Column(
                            children: [
                              Text(
                                'Счет',
                                style: TextStyle(
                                  fontFamily: 'Lato',
                                  color: auxText,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${_lastResult!.playerScore} : ${_lastResult!.aiScore}',
                                style: const TextStyle(
                                  fontFamily: 'Unbounded',
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: primaryText,
                                ),
                              ),
                            ],
                          ),
                          // Результат
                          Column(
                            children: [
                              Text(
                                'Итог',
                                style: TextStyle(
                                  fontFamily: 'Lato',
                                  color: auxText,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _lastResult!.resultText,
                                style: TextStyle(
                                  fontFamily: 'Unbounded',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: _lastResult!.isWin ? accentColor : Colors.redAccent,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Divider(color: Colors.grey.shade300),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 16,
                            color: auxText,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _formatDate(_lastResult!.date),
                            style: TextStyle(
                              fontFamily: 'Lato',
                              color: auxText,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: bgLight,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: auxText,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Здесь будет результат вашей последней игры',
                          style: TextStyle(
                            fontFamily: 'Lato',
                            color: auxText,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}