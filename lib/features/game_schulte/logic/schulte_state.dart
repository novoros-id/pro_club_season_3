class SchulteState {
  const SchulteState({
    required this.numbers,
    required this.expectedNumber,
    required this.errors,
    required this.elapsed,
    required this.isCompleted,
    this.highlightedNumber,
    this.highlightedWrongNumber,
  });

  final List<int> numbers;
  final int expectedNumber;
  final int errors;
  final Duration elapsed;
  final bool isCompleted;
  final int? highlightedNumber;
  final int? highlightedWrongNumber;

  SchulteState copyWith({
    List<int>? numbers,
    int? expectedNumber,
    int? errors,
    Duration? elapsed,
    bool? isCompleted,
    int? highlightedNumber,
    int? highlightedWrongNumber,
    bool clearHighlightedNumber = false,
    bool clearHighlightedWrongNumber = false,
  }) {
    return SchulteState(
      numbers: numbers ?? this.numbers,
      expectedNumber: expectedNumber ?? this.expectedNumber,
      errors: errors ?? this.errors,
      elapsed: elapsed ?? this.elapsed,
      isCompleted: isCompleted ?? this.isCompleted,
      highlightedNumber: clearHighlightedNumber
          ? null
          : highlightedNumber ?? this.highlightedNumber,
      highlightedWrongNumber: clearHighlightedWrongNumber
          ? null
          : highlightedWrongNumber ?? this.highlightedWrongNumber,
    );
  }
}
