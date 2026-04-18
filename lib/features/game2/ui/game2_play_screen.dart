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

  @override
  void initState() {
    super.initState();

    _gameLoopController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 16), // ~60 FPS
    )..addListener(_updateGame);

    _victoryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    // Запускаем игру через небольшую задержку
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(
              isWin ? Icons.emoji_events : Icons.sentiment_dissatisfied,
              color: isWin ? Colors.amber : Colors.grey,
              size: 40,
            ),
            const SizedBox(width: 12),
            Text(
              isWin ? 'Победа!' : 'Игра окончена',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isWin ? Colors.amber[700] : Colors.grey[800],
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
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '${state.playerScore} : ${state.aiScore}',
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isWin ? '🎉 Отличная игра!' : 'Попробуйте еще раз!',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              context.pop();
              context.pop();
            },
            child: const Text('В меню'),
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
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Играть снова'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(game2ControllerProvider);

    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: const Text('Аэрохоккей'),
        backgroundColor: Colors.blue[900],
        foregroundColor: Colors.white,
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
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.blue[900],
              ),
            ),

            const SizedBox(height: 16),

            // Игровое поле
            // Внутри build метода класса _Game2PlayScreenState
            // Игровое поле
            Expanded(
              child: Center(
                child: FittedBox(
                  fit: BoxFit.contain, // Идеально вписывает поле в экран, сохраняя пропорции
                  child: SizedBox(
                    width: Game2Controller.tableWidth,
                    height: Game2Controller.tableHeight,
                    child: GestureDetector(
                      onPanUpdate: (details) {
                        // Получаем координаты относительно ЭТОГО КОНКРЕТНОГО ПОЛЯ
                        final RenderBox box = context.findRenderObject() as RenderBox;
                        final Offset localPosition = box.globalToLocal(details.globalPosition);

                        // Так как FittedBox уже сделал всю работу по масштабированию визуальной части,
                        // а размер SizedBox равен логическому (400x600),
                        // то localPosition.dx/dy УЖЕ являются логическими координатами!
                        // Нам НЕ нужно делить на scale.

                        ref
                            .read(game2ControllerProvider.notifier)
                            .updatePlayerPaddle(localPosition);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.lightBlue[50]!,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
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