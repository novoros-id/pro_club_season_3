import 'daily_progress_stage.dart';

double dailyProgressSegmentFill({
  required double progress,
  required int segmentIndex,
}) => (progress * 10 - segmentIndex).clamp(0.0, 1.0);

int resolveDailyProgressMessageIndex({
  required int goalkeeperId,
  required DateTime date,
  required DailyProgressStage stage,
}) {
  var seed = goalkeeperId;
  seed = seed * 31 + date.year;
  seed = seed * 31 + date.month;
  seed = seed * 31 + date.day;
  seed = seed * 31 + stage.index;
  return seed % 3;
}
