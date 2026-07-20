class DailyTaskDayStats {
  final DateTime date;
  final int totalCount;
  final int completedCount;

  const DailyTaskDayStats({
    required this.date,
    required this.totalCount,
    required this.completedCount,
  });

  int get pending => totalCount - completedCount;
  double get completionPercent =>
      totalCount == 0 ? 0 : completedCount / totalCount * 100;
}

class DailyTaskStats {
  final int total;
  final int completed;
  final List<DailyTaskDayStats> recentDays;

  const DailyTaskStats({
    required this.total,
    required this.completed,
    required this.recentDays,
  });

  int get pending => total - completed;
  double get completionPercent => total == 0 ? 0 : completed / total * 100;
}
