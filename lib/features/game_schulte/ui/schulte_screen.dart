import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../logic/schulte_controller.dart';

class SchulteScreen extends ConsumerStatefulWidget {
  const SchulteScreen({super.key});

  @override
  ConsumerState<SchulteScreen> createState() => _SchulteScreenState();
}

class _SchulteScreenState extends ConsumerState<SchulteScreen> {
  static const _dark = Color(0xFF121212);
  static const _accent = Color(0xFFBBF246);
  static const _field = Color(0xFFF2F2F7);
  static const _secondary = Color(0xFF9B9EA1);
  static const _error = Color(0xFFFFD6D6);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(schulteControllerProvider.notifier).startGame();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(schulteControllerProvider);
    final controller = ref.read(schulteControllerProvider.notifier);

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
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Column(
            children: [
              _GameInfoCard(
                target: state.isCompleted
                    ? 'Готово'
                    : 'Найдите: ${state.expectedNumber}',
                elapsed: _formatDuration(state.elapsed),
                errors: state.errors,
              ),
              const SizedBox(height: 24),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final tableSide = constraints.biggest.shortestSide;
                    return Center(
                      child: SizedBox.square(
                        dimension: tableSide,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: state.tableSize,
                                    mainAxisSpacing: 8,
                                    crossAxisSpacing: 8,
                                  ),
                              itemCount: state.numbers.length,
                              itemBuilder: (context, index) {
                                final number = state.numbers[index];
                                final isCorrect =
                                    state.highlightedNumber == number;
                                final isWrong =
                                    state.highlightedWrongNumber == number;
                                final isCenterCell =
                                    state.tableSize.isOdd &&
                                    index == state.numbers.length ~/ 2;

                                return Material(
                                  color: isCorrect
                                      ? _accent
                                      : isWrong
                                      ? _error
                                      : Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: const BorderSide(
                                      color: Color(0xFFE2E3E7),
                                    ),
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  child: InkWell(
                                    onTap: state.isCompleted
                                        ? null
                                        : () =>
                                              controller.selectNumber(number),
                                    child: Align(
                                      alignment:
                                          state.showCenterDot && isCenterCell
                                          ? const Alignment(0, 0.55)
                                          : Alignment.center,
                                      child: Text(
                                        '$number',
                                        style: TextStyle(
                                          fontFamily: 'Lato',
                                          fontSize: state.tableSize == 6
                                              ? 18
                                              : 20,
                                          fontWeight: FontWeight.bold,
                                          color: _dark,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            if (state.showCenterDot)
                              IgnorePointer(
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: _dark,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              if (state.isCompleted) ...[
                const SizedBox(height: 24),
                Text(
                  'Итоговое время: ${_formatDuration(state.elapsed)}'
                  '  •  Ошибки: ${state.errors}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 16,
                    color: _secondary,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: FilledButton(
                    onPressed: controller.restart,
                    style: FilledButton.styleFrom(
                      backgroundColor: _dark,
                      foregroundColor: Colors.white,
                      shape: const StadiumBorder(),
                    ),
                    child: const Text(
                      'Начать заново',
                      style: TextStyle(
                        fontFamily: 'Unbounded',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
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

class _GameInfoCard extends StatelessWidget {
  const _GameInfoCard({
    required this.target,
    required this.elapsed,
    required this.errors,
  });

  final String target;
  final String elapsed;
  final int errors;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _SchulteScreenState._field,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            target,
            style: const TextStyle(
              fontFamily: 'Unbounded',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: _SchulteScreenState._dark,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Время: $elapsed',
                style: const TextStyle(
                  fontFamily: 'Lato',
                  fontSize: 16,
                  color: _SchulteScreenState._secondary,
                ),
              ),
              const SizedBox(width: 24),
              Text(
                'Ошибки: $errors',
                style: const TextStyle(
                  fontFamily: 'Lato',
                  fontSize: 16,
                  color: _SchulteScreenState._secondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
