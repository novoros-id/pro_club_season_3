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
    final initialState = _newGameState();
    _startTimer();
    return initialState;
  }

  void restart() {
    _correctHighlightTimer?.cancel();
    _wrongHighlightTimer?.cancel();
    _elapsedTimer?.cancel();
    _stopwatch
      ..reset()
      ..start();
    state = _newGameState();
    _scheduleElapsedUpdates();
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

    _correctHighlightTimer?.cancel();
    state = state.copyWith(
      expectedNumber: state.expectedNumber + 1,
      highlightedNumber: number,
      clearHighlightedWrongNumber: true,
    );
    _correctHighlightTimer = Timer(_highlightDuration, () {
      state = state.copyWith(clearHighlightedNumber: true);
    });

    if (number == 25) {
      _stopwatch.stop();
      _elapsedTimer?.cancel();
      state = state.copyWith(
        elapsed: _stopwatch.elapsed,
        isCompleted: true,
      );
    }
  }

  SchulteState _newGameState() {
    final numbers = List<int>.generate(25, (index) => index + 1)..shuffle();
    return SchulteState(
      numbers: numbers,
      expectedNumber: 1,
      errors: 0,
      elapsed: Duration.zero,
      isCompleted: false,
    );
  }

  void _startTimer() {
    _stopwatch
      ..reset()
      ..start();
    _scheduleElapsedUpdates();
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
