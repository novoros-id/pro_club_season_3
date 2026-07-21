import '../models/game_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../logic/game2_controller.dart';
import '../widgets/hockey_table_painter.dart';
import '../widgets/score_board.dart';

class Game2PlayScreen extends ConsumerStatefulWidget {
  const Game2PlayScreen({super.key});

  @override
  ConsumerState<Game2PlayScreen> createState() => _Game2PlayScreenState();
}

class _Game2PlayScreenState extends ConsumerState<Game2PlayScreen>
    with TickerProviderStateMixin {
  late AnimationController _gameLoopController;
  late AnimationController _victoryController;
  bool _showVictoryDialog = false;

  // 🎨 Дизайн-система
  static const Color primaryText = Color(0xFF121212);
  static const Color accentColor = Color(0xFFBBF246);
  static const Color bgLight = Color(0xFFF2F2F7);

  @override
  void initState() {
    super.initState();
    _gameLoopController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 16),
    )..addListener(_updateGame);

    _victoryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(game2ControllerProvider.notifier).startGame();
      _gameLoopController.repeat();
    });
  }

  @override
  void dispose() {
    _gameLoopController.dispose();
    _victoryController.dispose();
    super.dispose();
  }

  void _updateGame() {
    ref.read(game2ControllerProvider.notifier).updateGame();
    final state = ref.read(game2ControllerProvider);
    if (state.isGameOver && !_showVictoryDialog) {
      _showVictoryDialog = true;
      _victoryController.forward();
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          _showEndGameDialog(state);
        }
      });
    }
  }

  void _showEndGameDialog(GameState state) {
    final isWin = state.playerScore > state.aiScore;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(
              isWin ? Icons.emoji_events : Icons.sentiment_dissatisfied,
              color: isWin ? accentColor : primaryText,
              size: 40,
            ),
            const SizedBox(width: 12),
            Text(
              isWin ? 'ПОБЕДА!' : 'ИГРА ОКОНЧЕНА',
              style: TextStyle(
                fontFamily: 'Unbounded',
                fontWeight: FontWeight.bold,
                color: primaryText,
                fontSize: 20,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Финальный счет',
              style: TextStyle(
                fontFamily: 'Lato',
                fontSize: 16,
                color: const Color(0xFF9B9EA1),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '${state.playerScore} : ${state.aiScore}',
              style: const TextStyle(
                fontFamily: 'Unbounded',
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: primaryText,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isWin ? '🎉 Отличная игра!' : 'Попробуйте еще раз!',
              style: const TextStyle(fontFamily: 'Lato', fontSize: 16, color: primaryText),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              context.pop();
              context.pop();
            },
            child: const Text(
              'В МЕНЮ',
              style: TextStyle(color: Color(0xFF9B9EA1), fontFamily: 'Unbounded'),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              context.pop();
              setState(() {
                _showVictoryDialog = false;
              });
              ref.read(game2ControllerProvider.notifier).startGame();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryText, // Черная кнопка
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text(
              'ИГРАТЬ СНОВА',
              style: TextStyle(fontFamily: 'Unbounded', fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(game2ControllerProvider);

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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            _gameLoopController.stop();
            context.pop();
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            // Счет
            ScoreBoard(
              playerScore: gameState.playerScore,
              aiScore: gameState.aiScore,
              winningScore: Game2Controller.winningScore,
            ),
            const SizedBox(height: 16),
            // Инструкции
            Text(
              'Первый до ${Game2Controller.winningScore} голов!',
              style: TextStyle(
                fontFamily: 'Lato',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF9B9EA1),
              ),
            ),
            const SizedBox(height: 16),
            // Игровое поле
            Expanded(
              child: Center(
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: SizedBox(
                    width: Game2Controller.tableWidth,
                    height: Game2Controller.tableHeight,
                    child: GestureDetector(
                      onPanUpdate: (details) {
                        final RenderBox box = context.findRenderObject() as RenderBox;
                        final Offset localPosition = box.globalToLocal(details.globalPosition);
                        ref
                            .read(game2ControllerProvider.notifier)
                            .updatePlayerPaddle(localPosition);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: bgLight, // Светло-серый фон контейнера поля
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: CustomPaint(
                          size: const Size(Game2Controller.tableWidth, Game2Controller.tableHeight),
                          painter: HockeyTablePainter(gameState: gameState),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}