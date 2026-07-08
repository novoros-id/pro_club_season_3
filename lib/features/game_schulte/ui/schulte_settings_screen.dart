import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../logic/schulte_controller.dart';

class SchulteSettingsScreen extends ConsumerWidget {
  const SchulteSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(schulteControllerProvider);
    final controller = ref.read(schulteControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Настройки')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              'Размер таблицы',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            SegmentedButton<int>(
              segments: const [
                ButtonSegment(value: 4, label: Text('4×4')),
                ButtonSegment(value: 5, label: Text('5×5')),
                ButtonSegment(value: 6, label: Text('6×6')),
              ],
              selected: {state.tableSize},
              onSelectionChanged: (selection) {
                controller.setTableSize(selection.first);
              },
            ),
            const SizedBox(height: 24),
            Text(
              'Перемешивать при клике',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment(value: true, label: Text('Да')),
                ButtonSegment(value: false, label: Text('Нет')),
              ],
              selected: {state.shuffleOnClick},
              onSelectionChanged: (selection) {
                controller.setShuffleOnClick(selection.first);
              },
            ),
            const SizedBox(height: 24),
            Text(
              'Добавить точку в центре',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment(value: true, label: Text('Да')),
                ButtonSegment(value: false, label: Text('Нет')),
              ],
              selected: {state.showCenterDot},
              onSelectionChanged: (selection) {
                controller.setShowCenterDot(selection.first);
              },
            ),
          ],
        ),
      ),
    );
  }
}
