class DailyTaskDayStats {
  final DateTime date;
  final int total;
  final int completed;

  const DailyTaskDayStats({
    required this.date,
    required this.total,
    required this.completed,
  });

  int get pending => total - completed;
  double get completionPercent => total == 0 ? 0 : completed / total * 100;
}

class DailyTaskStats {
  final int total;
  final int completed;
  final List<DailyTaskDayStats> lastSevenDays;

  const DailyTaskStats({
    required this.total,
    required this.completed,
    required this.lastSevenDays,
  });

  int get pending => total - completed;
  double get completionPercent => total == 0 ? 0 : completed / total * 100;
}
