import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../logic/schulte_controller.dart';

class SchulteHomeScreen extends ConsumerWidget {
  const SchulteHomeScreen({super.key});

  static const _dark = Color(0xFF121212);
  static const _field = Color(0xFFF2F2F7);
  static const _secondary = Color(0xFF9B9EA1);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(schulteControllerProvider);
    final statistics = state.currentStatistics;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: _dark,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: const FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            'Таблица Шульте',
            style: TextStyle(
              fontFamily: 'Unbounded',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: _dark,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _StatisticsCard(
                tableSize: state.tableSize,
                totalGames: statistics?.totalGames,
                bestTime: statistics == null
                    ? null
                    : _formatDuration(statistics.bestTime),
                averageTime: statistics == null
                    ? null
                    : _formatDuration(statistics.averageTime),
                lastAttempt: statistics == null
                    ? null
                    : '${_formatDuration(statistics.lastResult.elapsed)}, '
                          'ошибок: ${statistics.lastResult.errors}',
              ),
              const SizedBox(height: 24),
              _PrimaryButton(
                title: 'Играть',
                onPressed: () => context.push('/game_schulte/play'),
              ),
              const SizedBox(height: 16),
              _PrimaryButton(
                title: 'Настройки',
                onPressed: () => context.push('/game_schulte/settings'),
              ),
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

class _StatisticsCard extends StatelessWidget {
  const _StatisticsCard({
    required this.tableSize,
    required this.totalGames,
    required this.bestTime,
    required this.averageTime,
    required this.lastAttempt,
  });

  final int tableSize;
  final int? totalGames;
  final String? bestTime;
  final String? averageTime;
  final String? lastAttempt;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: SchulteHomeScreen._field,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Статистика $tableSize×$tableSize',
            style: const TextStyle(
              fontFamily: 'Unbounded',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: SchulteHomeScreen._dark,
            ),
          ),
          const SizedBox(height: 16),
          if (totalGames == null)
            const Text(
              'Пока нет сыгранных игр',
              style: TextStyle(
                fontFamily: 'Lato',
                fontSize: 16,
                color: SchulteHomeScreen._secondary,
              ),
            )
          else ...[
            _StatisticRow(label: 'Всего игр', value: '$totalGames'),
            const SizedBox(height: 8),
            _StatisticRow(label: 'Лучшее время', value: bestTime!),
            const SizedBox(height: 8),
            _StatisticRow(label: 'Среднее время', value: averageTime!),
            const SizedBox(height: 8),
            _StatisticRow(label: 'Последняя попытка', value: lastAttempt!),
          ],
        ],
      ),
    );
  }
}

class _StatisticRow extends StatelessWidget {
  const _StatisticRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: 'Lato',
              fontSize: 16,
              color: SchulteHomeScreen._secondary,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(
              fontFamily: 'Lato',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: SchulteHomeScreen._dark,
            ),
          ),
        ),
      ],
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({required this.title, required this.onPressed});

  final String title;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: SchulteHomeScreen._dark,
          foregroundColor: Colors.white,
          shape: const StadiumBorder(),
        ),
        child: Text(
          title,
          style: const TextStyle(
            fontFamily: 'Unbounded',
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
