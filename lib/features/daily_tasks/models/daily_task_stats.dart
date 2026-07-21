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
  final int totalTasksToday;
  final int completedToday;
  final List<DailyTaskDayStats> recentDays;

  const DailyTaskStats({
    required this.totalTasksToday,
    required this.completedToday,
    required this.recentDays,
  });

  int get remainingActiveTasksToday => totalTasksToday - completedToday;
  double get completionPercentToday => totalTasksToday == 0
      ? 0
      : completedToday / totalTasksToday * 100;

  // Kept as aliases for existing consumers of the model.
  int get total => totalTasksToday;
  int get completed => completedToday;
  int get pending => remainingActiveTasksToday;
  double get completionPercent => completionPercentToday;
}
