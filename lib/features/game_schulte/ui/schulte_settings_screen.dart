import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../logic/schulte_controller.dart';

class SchulteSettingsScreen extends ConsumerWidget {
  const SchulteSettingsScreen({super.key});

  static const _dark = Color(0xFF121212);
  static const _accent = Color(0xFFBBF246);
  static const _field = Color(0xFFF2F2F7);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(schulteControllerProvider);
    final controller = ref.read(schulteControllerProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: _dark,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: const Text(
          'Настройки',
          style: TextStyle(
            fontFamily: 'Unbounded',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: _dark,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            _SettingsCard(
              title: 'Размер таблицы',
              child: SegmentedButton<int>(
                segments: const [
                  ButtonSegment(value: 4, label: Text('4×4')),
                  ButtonSegment(value: 5, label: Text('5×5')),
                  ButtonSegment(value: 6, label: Text('6×6')),
                ],
                selected: {state.tableSize},
                style: _segmentStyle,
                onSelectionChanged: (selection) {
                  controller.setTableSize(selection.first);
                },
              ),
            ),
            const SizedBox(height: 16),
            _SettingsCard(
              title: 'Перемешивать при клике',
              child: SegmentedButton<bool>(
                segments: const [
                  ButtonSegment(value: true, label: Text('Да')),
                  ButtonSegment(value: false, label: Text('Нет')),
                ],
                selected: {state.shuffleOnClick},
                style: _segmentStyle,
                onSelectionChanged: (selection) {
                  controller.setShuffleOnClick(selection.first);
                },
              ),
            ),
            const SizedBox(height: 16),
            _SettingsCard(
              title: 'Добавить точку в центре',
              child: SegmentedButton<bool>(
                segments: const [
                  ButtonSegment(value: true, label: Text('Да')),
                  ButtonSegment(value: false, label: Text('Нет')),
                ],
                selected: {state.showCenterDot},
                style: _segmentStyle,
                onSelectionChanged: (selection) {
                  controller.setShowCenterDot(selection.first);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  static final ButtonStyle _segmentStyle = ButtonStyle(
    backgroundColor: WidgetStateProperty.resolveWith(
      (states) => states.contains(WidgetState.selected)
          ? _accent
          : Colors.white,
    ),
    foregroundColor: const WidgetStatePropertyAll(_dark),
    textStyle: const WidgetStatePropertyAll(
      TextStyle(fontFamily: 'Lato', fontSize: 16),
    ),
    side: const WidgetStatePropertyAll(
      BorderSide(color: _accent),
    ),
  );
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: SchulteSettingsScreen._field,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Lato',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: SchulteSettingsScreen._dark,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(width: double.infinity, child: child),
        ],
      ),
    );
  }
}
