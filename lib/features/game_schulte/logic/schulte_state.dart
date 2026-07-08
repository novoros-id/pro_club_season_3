class SchulteGameResult {
  const SchulteGameResult({
    required this.tableSize,
    required this.elapsed,
    required this.errors,
  });

  final int tableSize;
  final Duration elapsed;
  final int errors;
}

class SchulteStatistics {
  const SchulteStatistics({
    required this.totalGames,
    required this.bestTime,
    required this.averageTime,
    required this.lastResult,
  });

  final int totalGames;
  final Duration bestTime;
  final Duration averageTime;
  final SchulteGameResult lastResult;
}

class SchulteState {
  const SchulteState({
    required this.numbers,
    required this.tableSize,
    required this.expectedNumber,
    required this.errors,
    required this.elapsed,
    required this.isCompleted,
    required this.shuffleOnClick,
    required this.showCenterDot,
    required this.resultsByTableSize,
    this.highlightedNumber,
    this.highlightedWrongNumber,
  });

  final List<int> numbers;
  final int tableSize;
  final int expectedNumber;
  final int errors;
  final Duration elapsed;
  final bool isCompleted;
  final bool shuffleOnClick;
  final bool showCenterDot;
  final Map<int, List<SchulteGameResult>> resultsByTableSize;
  final int? highlightedNumber;
  final int? highlightedWrongNumber;

  SchulteStatistics? get currentStatistics {
    final results = resultsByTableSize[tableSize];
    if (results == null || results.isEmpty) return null;

    final bestTime = results
        .map((result) => result.elapsed)
        .reduce((best, value) => value < best ? value : best);
    final totalMicroseconds = results.fold<int>(
      0,
      (total, result) => total + result.elapsed.inMicroseconds,
    );

    return SchulteStatistics(
      totalGames: results.length,
      bestTime: bestTime,
      averageTime: Duration(
        microseconds: totalMicroseconds ~/ results.length,
      ),
      lastResult: results.last,
    );
  }

  SchulteState copyWith({
    List<int>? numbers,
    int? tableSize,
    int? expectedNumber,
    int? errors,
    Duration? elapsed,
    bool? isCompleted,
    bool? shuffleOnClick,
    bool? showCenterDot,
    Map<int, List<SchulteGameResult>>? resultsByTableSize,
    int? highlightedNumber,
    int? highlightedWrongNumber,
    bool clearHighlightedNumber = false,
    bool clearHighlightedWrongNumber = false,
  }) {
    return SchulteState(
      numbers: numbers ?? this.numbers,
      tableSize: tableSize ?? this.tableSize,
      expectedNumber: expectedNumber ?? this.expectedNumber,
      errors: errors ?? this.errors,
      elapsed: elapsed ?? this.elapsed,
      isCompleted: isCompleted ?? this.isCompleted,
      shuffleOnClick: shuffleOnClick ?? this.shuffleOnClick,
      showCenterDot: showCenterDot ?? this.showCenterDot,
      resultsByTableSize: resultsByTableSize ?? this.resultsByTableSize,
      highlightedNumber: clearHighlightedNumber
          ? null
          : highlightedNumber ?? this.highlightedNumber,
      highlightedWrongNumber: clearHighlightedWrongNumber
          ? null
          : highlightedWrongNumber ?? this.highlightedWrongNumber,
    );
  }
}
