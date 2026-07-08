import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../logic/schulte_controller.dart';

class SchulteScreen extends ConsumerStatefulWidget {
  const SchulteScreen({super.key});

  @override
  ConsumerState<SchulteScreen> createState() => _SchulteScreenState();
}

class _SchulteScreenState extends ConsumerState<SchulteScreen> {
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
      appBar: AppBar(title: const Text('Таблица Шульте')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                state.isCompleted
                    ? 'Готово'
                    : 'Найдите: ${state.expectedNumber}',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                'Время: ${_formatDuration(state.elapsed)}  '
                'Ошибки: ${state.errors}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 24),
              Expanded(
                child: Center(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: state.tableSize,
                                mainAxisSpacing: 6,
                                crossAxisSpacing: 6,
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
                                  ? Colors.green
                                  : isWrong
                                  ? Colors.red
                                  : Theme.of(
                                      context,
                                    ).colorScheme.surfaceContainer,
                              borderRadius: BorderRadius.circular(8),
                              child: InkWell(
                                onTap: state.isCompleted
                                    ? null
                                    : () => controller.selectNumber(number),
                                borderRadius: BorderRadius.circular(8),
                                child: Align(
                                  alignment: state.showCenterDot && isCenterCell
                                      ? const Alignment(0, 0.55)
                                      : Alignment.center,
                                  child: Text(
                                    '$number',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleLarge,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        if (state.showCenterDot)
                          IgnorePointer(
                            child: Container(
                              width: 7,
                              height: 7,
                              decoration: const BoxDecoration(
                                color: Colors.black,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              if (state.isCompleted) ...[
                const SizedBox(height: 24),
                Text(
                  'Итоговое время: ${_formatDuration(state.elapsed)}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  'Ошибки: ${state.errors}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: controller.restart,
                  child: const Text('Начать заново'),
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
