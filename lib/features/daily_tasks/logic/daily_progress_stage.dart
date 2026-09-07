enum DailyProgressStage {
  noTasks,
  percent0,
  percent20,
  percent40,
  percent60,
  percent80,
  percent100,
}

DailyProgressStage resolveDailyProgressStage({
  required int completedCount,
  required int totalCount,
}) {
  if (totalCount == 0) return DailyProgressStage.noTasks;
  if (completedCount == 0) return DailyProgressStage.percent0;
  if (completedCount >= totalCount) return DailyProgressStage.percent100;

  final completionRatio = completedCount / totalCount;
  if (completionRatio >= 0.8) return DailyProgressStage.percent80;
  if (completionRatio >= 0.6) return DailyProgressStage.percent60;
  if (completionRatio >= 0.4) return DailyProgressStage.percent40;
  return DailyProgressStage.percent20;
}
