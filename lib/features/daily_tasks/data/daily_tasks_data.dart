import 'package:drift/drift.dart';
import '../../../core/database/app_database.dart';
import '../models/daily_task.dart';
import '../models/daily_task_stats.dart';
import '../logic/daily_task_date.dart';

class DailyTasksData {
  final AppDatabase db;
  const DailyTasksData(this.db);

  Future<Goalkeeper?> currentGoalkeeper() => db.getCurrentGoalkeeper();

  Future<List<DailyTaskItem>> tasksForDate(
    int goalkeeperId,
    DateTime date,
  ) async {
    final day = normalizeOccurrenceDate(date);
    final tasks =
        await (db.select(db.dailyTasks)..where(
              (t) =>
                  t.goalkeeperId.equals(goalkeeperId) &
                  t.isEnabled.equals(true) &
                  t.deletedAt.isNull(),
            ))
            .get();
    if (tasks.isEmpty) return [];
    final completions = await (db.select(
      db.dailyTaskCompletions,
    )..where((c) => c.occurrenceDate.equals(day))).get();
    final completedIds = completions
        .map((completion) => completion.taskId)
        .toSet();
    return tasks
        .map(
          (task) => DailyTaskItem(
            task: task,
            isCompleted: completedIds.contains(task.id),
          ),
        )
        .toList();
  }

  Future<int> createTask(DailyTasksCompanion task) =>
      db.into(db.dailyTasks).insert(task);

  Future<void> updateTask(
    int id, {
    required String title,
    String? description,
  }) async {
    await (db.update(db.dailyTasks)..where((t) => t.id.equals(id))).write(
      DailyTasksCompanion(
        title: Value(title),
        description: Value(description),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> setEnabled(int id, bool enabled) async {
    await (db.update(db.dailyTasks)..where((t) => t.id.equals(id))).write(
      DailyTasksCompanion(
        isEnabled: Value(enabled),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> softDelete(int id) async {
    final now = DateTime.now();
    await (db.update(db.dailyTasks)..where((t) => t.id.equals(id))).write(
      DailyTasksCompanion(deletedAt: Value(now), updatedAt: Value(now)),
    );
  }

  Future<void> complete(int taskId, DateTime date) async {
    final day = normalizeOccurrenceDate(date);
    await db
        .into(db.dailyTaskCompletions)
        .insert(
          DailyTaskCompletionsCompanion.insert(
            taskId: taskId,
            occurrenceDate: day,
          ),
          mode: InsertMode.insertOrIgnore,
        );
  }

  Future<void> uncomplete(int taskId, DateTime date) async {
    final day = normalizeOccurrenceDate(date);
    await (db.delete(
          db.dailyTaskCompletions,
        )..where((c) => c.taskId.equals(taskId) & c.occurrenceDate.equals(day)))
        .go();
  }

  Future<DailyTaskStats> stats(int goalkeeperId, DateTime date) async {
    final active =
        await (db.select(db.dailyTasks)..where(
              (t) =>
                  t.goalkeeperId.equals(goalkeeperId) &
                  t.isEnabled.equals(true) &
                  t.deletedAt.isNull(),
            ))
            .get();
    final ids = active.map((task) => task.id).toList();
    final days = <DailyTaskDayStats>[];
    final today = normalizeOccurrenceDate(date);
    for (var offset = 6; offset >= 0; offset--) {
      final day = today.subtract(Duration(days: offset));
      final completions = ids.isEmpty
          ? <DailyTaskCompletion>[]
          : await (db.select(db.dailyTaskCompletions)..where(
                  (c) => c.occurrenceDate.equals(day) & c.taskId.isIn(ids),
                ))
                .get();
      days.add(
        DailyTaskDayStats(
          date: day,
          total: active.length,
          completed: completions.length,
        ),
      );
    }
    final current = days.last;
    return DailyTaskStats(
      total: current.total,
      completed: current.completed,
      lastSevenDays: days,
    );
  }
}
