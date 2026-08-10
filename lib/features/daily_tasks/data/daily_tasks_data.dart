import 'package:drift/drift.dart';
import '../../../core/database/app_database.dart';
import '../models/daily_task.dart';
import '../models/daily_task_stats.dart';
import '../logic/daily_task_date.dart';

class DailyTaskAccessException implements Exception {
  const DailyTaskAccessException();

  @override
  String toString() =>
      'DailyTaskAccessException: task not found, unavailable, or owned by another goalkeeper';
}

class DailyTasksData {
  final AppDatabase db;
  const DailyTasksData(this.db);

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
    final taskIds = tasks.map((task) => task.id).toList();
    final completions =
        await (db.select(db.dailyTaskCompletions)..where(
              (c) => c.occurrenceDate.equals(day) & c.taskId.isIn(taskIds),
            ))
            .get();
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

  Future<int> createTask({
    required int goalkeeperId,
    required String title,
    String? description,
    bool enabled = true,
    String? uuid,
    DateTime? createdAt,
  }) => db
      .into(db.dailyTasks)
      .insert(
        DailyTasksCompanion.insert(
          uuid: uuid == null ? const Value.absent() : Value(uuid),
          goalkeeperId: goalkeeperId,
          title: title,
          description: Value(description),
          isEnabled: Value(enabled),
          createdAt: createdAt == null
              ? const Value.absent()
              : Value(createdAt),
        ),
      );

  Future<void> updateTask(
    int goalkeeperId,
    int taskId, {
    required String title,
    String? description,
  }) async {
    final changed =
        await (db.update(db.dailyTasks)..where(
              (task) =>
                  task.id.equals(taskId) &
                  task.goalkeeperId.equals(goalkeeperId) &
                  task.deletedAt.isNull(),
            ))
            .write(
              DailyTasksCompanion(
                title: Value(title),
                description: Value(description),
                updatedAt: Value(DateTime.now()),
              ),
            );
    if (changed == 0) throw const DailyTaskAccessException();
  }

  Future<void> setEnabled(int goalkeeperId, int taskId, bool enabled) async {
    final changed =
        await (db.update(db.dailyTasks)..where(
              (task) =>
                  task.id.equals(taskId) &
                  task.goalkeeperId.equals(goalkeeperId) &
                  task.deletedAt.isNull(),
            ))
            .write(
              DailyTasksCompanion(
                isEnabled: Value(enabled),
                updatedAt: Value(DateTime.now()),
              ),
            );
    if (changed == 0) throw const DailyTaskAccessException();
  }

  Future<void> softDelete(int goalkeeperId, int taskId) async {
    final now = DateTime.now();
    final changed =
        await (db.update(db.dailyTasks)..where(
              (task) =>
                  task.id.equals(taskId) &
                  task.goalkeeperId.equals(goalkeeperId) &
                  task.deletedAt.isNull(),
            ))
            .write(
              DailyTasksCompanion(deletedAt: Value(now), updatedAt: Value(now)),
            );
    if (changed == 0) throw const DailyTaskAccessException();
  }

  Future<void> complete(int goalkeeperId, int taskId, DateTime date) async {
    final day = normalizeOccurrenceDate(date);
    await db.transaction(() async {
      await _requireCompletableTask(goalkeeperId: goalkeeperId, taskId: taskId);
      await db
          .into(db.dailyTaskCompletions)
          .insert(
            DailyTaskCompletionsCompanion.insert(
              taskId: taskId,
              occurrenceDate: day,
            ),
            mode: InsertMode.insertOrIgnore,
          );
    });
  }

  Future<void> uncomplete(int goalkeeperId, int taskId, DateTime date) async {
    final day = normalizeOccurrenceDate(date);
    await db.transaction(() async {
      await _requireCompletableTask(goalkeeperId: goalkeeperId, taskId: taskId);
      await (db.delete(db.dailyTaskCompletions)..where(
            (completion) =>
                completion.taskId.equals(taskId) &
                completion.occurrenceDate.equals(day),
          ))
          .go();
    });
  }

  Future<DailyTaskStats> stats(int goalkeeperId, DateTime date) async {
    final tasks = await (db.select(
      db.dailyTasks,
    )..where((t) => t.goalkeeperId.equals(goalkeeperId))).get();
    final daysWithCompletions = <DailyTaskDayStats>[];
    final today = normalizeOccurrenceDate(date);
    final firstDay = today.subtract(const Duration(days: 2));
    final completionQuery = db.select(db.dailyTaskCompletions).join([
      innerJoin(
        db.dailyTasks,
        db.dailyTasks.id.equalsExp(db.dailyTaskCompletions.taskId) &
            db.dailyTasks.goalkeeperId.equals(goalkeeperId),
      ),
    ]);
    completionQuery.where(
      db.dailyTaskCompletions.occurrenceDate.isBetweenValues(firstDay, today),
    );
    final completionRows = await completionQuery.get();
    final completions = completionRows
        .map((row) => row.readTable(db.dailyTaskCompletions))
        .toList();
    final completionsByDay = <DateTime, List<DailyTaskCompletion>>{};
    for (final completion in completions) {
      completionsByDay
          .putIfAbsent(completion.occurrenceDate, () => [])
          .add(completion);
    }

    for (var offset = 2; offset >= 0; offset--) {
      final day = today.subtract(Duration(days: offset));
      final tasksForDay = tasks.where((task) {
        final nextDay = day.add(const Duration(days: 1));
        final existedOnDay =
            task.createdAt.isBefore(nextDay) &&
            (task.deletedAt == null || task.deletedAt!.isAfter(day));

        // The database has no isEnabled history. For past days we therefore
        // only use creation and deletion dates, avoiding false assumptions.
        final isCurrentDay = day == normalizeOccurrenceDate(DateTime.now());
        return existedOnDay && (!isCurrentDay || task.isEnabled);
      }).toList();
      final ids = tasksForDay.map((task) => task.id).toSet();
      final completedCount = (completionsByDay[day] ?? const [])
          .where((completion) => ids.contains(completion.taskId))
          .length;
      if (completedCount == 0) continue;
      daysWithCompletions.add(
        DailyTaskDayStats(
          date: day,
          totalCount: tasksForDay.length,
          completedCount: completedCount,
        ),
      );
    }
    final currentTasks = tasks.where(
      (task) =>
          task.createdAt.isBefore(today.add(const Duration(days: 1))) &&
          task.isEnabled &&
          task.deletedAt == null,
    );
    final currentIds = currentTasks.map((task) => task.id).toSet();
    final completedToday = (completionsByDay[today] ?? const [])
        .where((completion) => currentIds.contains(completion.taskId))
        .length;
    return DailyTaskStats(
      totalTasksToday: currentIds.length,
      completedToday: completedToday,
      recentDays: daysWithCompletions,
    );
  }

  Future<void> _requireCompletableTask({
    required int goalkeeperId,
    required int taskId,
  }) async {
    final task =
        await (db.select(db.dailyTasks)..where(
              (task) =>
                  task.id.equals(taskId) &
                  task.goalkeeperId.equals(goalkeeperId) &
                  task.isEnabled.equals(true) &
                  task.deletedAt.isNull(),
            ))
            .getSingleOrNull();
    if (task == null) throw const DailyTaskAccessException();
  }
}
