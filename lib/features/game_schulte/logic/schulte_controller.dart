import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'schulte_state.dart';

final schulteControllerProvider =
    NotifierProvider<SchulteController, SchulteState>(SchulteController.new);

class SchulteController extends Notifier<SchulteState> {
  static const _highlightDuration = Duration(milliseconds: 160);

  final Stopwatch _stopwatch = Stopwatch();
  Timer? _elapsedTimer;
  Timer? _correctHighlightTimer;
  Timer? _wrongHighlightTimer;

  @override
  SchulteState build() {
    ref.onDispose(_dispose);
    return const SchulteState(
      numbers: [],
      tableSize: 5,
      expectedNumber: 1,
      errors: 0,
      elapsed: Duration.zero,
      isCompleted: false,
      shuffleOnClick: false,
      showCenterDot: false,
      resultsByTableSize: {},
    );
  }

  void setTableSize(int tableSize) {
    state = state.copyWith(tableSize: tableSize);
  }

  void setShuffleOnClick(bool value) {
    state = state.copyWith(shuffleOnClick: value);
  }

  void setShowCenterDot(bool value) {
    state = state.copyWith(showCenterDot: value);
  }

  void startGame() {
    _correctHighlightTimer?.cancel();
    _wrongHighlightTimer?.cancel();
    _elapsedTimer?.cancel();
    _stopwatch
      ..reset()
      ..start();
    state = state.copyWith(
      numbers: _generateNumbers(),
      expectedNumber: 1,
      errors: 0,
      elapsed: Duration.zero,
      isCompleted: false,
      clearHighlightedNumber: true,
      clearHighlightedWrongNumber: true,
    );
    _scheduleElapsedUpdates();
  }

  void restart() {
    startGame();
  }

  void selectNumber(int number) {
    if (state.isCompleted) return;

    if (number != state.expectedNumber) {
      _wrongHighlightTimer?.cancel();
      state = state.copyWith(
        errors: state.errors + 1,
        highlightedWrongNumber: number,
      );
      _wrongHighlightTimer = Timer(_highlightDuration, () {
        state = state.copyWith(clearHighlightedWrongNumber: true);
      });
      return;
    }

    final lastNumber = state.tableSize * state.tableSize;
    _correctHighlightTimer?.cancel();
    state = state.copyWith(
      numbers: state.shuffleOnClick ? _generateNumbers() : null,
      expectedNumber: state.expectedNumber + 1,
      highlightedNumber: number,
      clearHighlightedWrongNumber: true,
    );
    _correctHighlightTimer = Timer(_highlightDuration, () {
      state = state.copyWith(clearHighlightedNumber: true);
    });

    if (number == lastNumber) {
      _completeGame();
    }
  }

  List<int> _generateNumbers() {
    return List<int>.generate(
      state.tableSize * state.tableSize,
      (index) => index + 1,
    )..shuffle();
  }

  void _completeGame() {
    _stopwatch.stop();
    _elapsedTimer?.cancel();

    final result = SchulteGameResult(
      tableSize: state.tableSize,
      elapsed: _stopwatch.elapsed,
      errors: state.errors,
    );
    final results = Map<int, List<SchulteGameResult>>.from(
      state.resultsByTableSize,
    );
    results[state.tableSize] = [
      ...(results[state.tableSize] ?? const []),
      result,
    ];

    state = state.copyWith(
      elapsed: result.elapsed,
      isCompleted: true,
      resultsByTableSize: results,
    );
  }

  void _scheduleElapsedUpdates() {
    _elapsedTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      state = state.copyWith(elapsed: _stopwatch.elapsed);
    });
  }

  void _dispose() {
    _elapsedTimer?.cancel();
    _correctHighlightTimer?.cancel();
    _wrongHighlightTimer?.cancel();
    _stopwatch.stop();
  }
}
