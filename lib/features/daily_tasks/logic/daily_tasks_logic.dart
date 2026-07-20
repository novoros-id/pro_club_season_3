import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';
import '../data/daily_tasks_data.dart';
import '../models/daily_task.dart';
import '../models/daily_task_stats.dart';
import 'daily_task_date.dart';

class DailyTasksState {
  final int? goalkeeperId;
  final DateTime date;
  final List<DailyTaskItem> tasks;
  final DailyTaskStats stats;
  final bool isLoading;
  final Object? error;

  const DailyTasksState({
    this.goalkeeperId,
    required this.date,
    this.tasks = const [],
    this.stats = const DailyTaskStats(total: 0, completed: 0, recentDays: []),
    this.isLoading = false,
    this.error,
  });

  DailyTasksState copyWith({
    int? goalkeeperId,
    bool clearGoalkeeper = false,
    DateTime? date,
    List<DailyTaskItem>? tasks,
    DailyTaskStats? stats,
    bool? isLoading,
    Object? error,
    bool clearError = false,
  }) => DailyTasksState(
    goalkeeperId: clearGoalkeeper ? null : goalkeeperId ?? this.goalkeeperId,
    date: date ?? this.date,
    tasks: tasks ?? this.tasks,
    stats: stats ?? this.stats,
    isLoading: isLoading ?? this.isLoading,
    error: clearError ? null : error ?? this.error,
  );
}

final dailyTasksControllerProvider =
    NotifierProvider<DailyTasksController, DailyTasksState>(
      DailyTasksController.new,
    );

class DailyTasksController extends Notifier<DailyTasksState> {
  late final DailyTasksData _data;

  @override
  DailyTasksState build() {
    _data = DailyTasksData(ref.read(databaseProvider));
    final initial = DailyTasksState(
      date: normalizeOccurrenceDate(DateTime.now()),
      isLoading: true,
    );
    _load();
    return initial;
  }

  Future<void> _load() async {
    try {
      final keeper = await _data.currentGoalkeeper();
      if (keeper == null) {
        state = state.copyWith(
          clearGoalkeeper: true,
          tasks: [],
          stats: const DailyTaskStats(total: 0, completed: 0, recentDays: []),
          isLoading: false,
        );
        return;
      }
      final tasks = await _data.tasksForDate(keeper.id, state.date);
      final stats = await _data.stats(keeper.id, state.date);
      state = state.copyWith(
        goalkeeperId: keeper.id,
        tasks: tasks,
        stats: stats,
        isLoading: false,
        clearError: true,
      );
    } catch (error) {
      state = state.copyWith(isLoading: false, error: error);
    }
  }

  Future<void> refresh() => _load();

  Future<void> selectDate(DateTime date) async {
    state = state.copyWith(
      date: normalizeOccurrenceDate(date),
      isLoading: true,
    );
    await _load();
  }

  Future<void> createTask({
    required String title,
    String? description,
    bool enabled = true,
  }) async {
    final id = state.goalkeeperId;
    if (id == null) return;
    await _data.createTask(
      DailyTasksCompanion.insert(
        goalkeeperId: id,
        title: title,
        description: Value(description),
        isEnabled: Value(enabled),
      ),
    );
    await _load();
  }

  Future<void> updateTask(
    int taskId, {
    required String title,
    String? description,
    bool? enabled,
  }) async {
    await _data.updateTask(taskId, title: title, description: description);
    if (enabled != null) await _data.setEnabled(taskId, enabled);
    await _load();
  }

  Future<void> setEnabled(int taskId, bool enabled) async {
    await _data.setEnabled(taskId, enabled);
    await _load();
  }

  Future<void> deleteTask(int taskId) async {
    await _data.softDelete(taskId);
    await _load();
  }

  Future<void> setCompleted(int taskId, bool completed) async {
    if (completed) {
      await _data.complete(taskId, state.date);
    } else {
      await _data.uncomplete(taskId, state.date);
    }
    await _load();
  }
}
