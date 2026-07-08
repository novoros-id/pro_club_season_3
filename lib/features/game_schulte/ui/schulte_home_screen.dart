import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../logic/schulte_controller.dart';

class SchulteHomeScreen extends ConsumerWidget {
  const SchulteHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(schulteControllerProvider);
    final statistics = state.currentStatistics;

    return Scaffold(
      appBar: AppBar(title: const Text('Таблица Шульте')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FilledButton(
                onPressed: () => context.push('/game_schulte/play'),
                child: const Text('Играть'),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => context.push('/game_schulte/settings'),
                child: const Text('Настройки'),
              ),
              const SizedBox(height: 32),
              Text(
                'Статистика ${state.tableSize}×${state.tableSize}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              if (statistics == null)
                const Text('Пока нет сыгранных игр')
              else ...[
                Text('Всего игр: ${statistics.totalGames}'),
                Text(
                  'Лучшее время: ${_formatDuration(statistics.bestTime)}',
                ),
                Text(
                  'Среднее время: ${_formatDuration(statistics.averageTime)}',
                ),
                Text(
                  'Последняя попытка: '
                  '${_formatDuration(statistics.lastResult.elapsed)}, '
                  'ошибок: ${statistics.lastResult.errors}',
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
