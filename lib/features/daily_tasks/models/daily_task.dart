import '../../../core/database/app_database.dart';

class DailyTaskItem {
  final DailyTask task;
  final bool isCompleted;

  const DailyTaskItem({required this.task, required this.isCompleted});
}
