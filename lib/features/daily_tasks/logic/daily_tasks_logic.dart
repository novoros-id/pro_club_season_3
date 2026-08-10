import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/database_provider.dart';
import '../../registration/logic/goalkeepers_controller.dart';
import '../data/daily_tasks_data.dart';
import '../models/daily_task.dart';
import '../models/daily_task_stats.dart';
import 'daily_task_date.dart';

const _emptyDailyTaskStats = DailyTaskStats(
  totalTasksToday: 0,
  completedToday: 0,
  recentDays: [],
);

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
    this.stats = _emptyDailyTaskStats,
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

final dailyTasksDataProvider = Provider<DailyTasksData>(
  (ref) => DailyTasksData(ref.read(databaseProvider)),
);

class DailyTasksScopeException implements Exception {
  const DailyTasksScopeException();

  @override
  String toString() =>
      'DailyTasksScopeException: there is no matching active goalkeeper';
}

class DailyTasksController extends Notifier<DailyTasksState> {
  late DailyTasksData _data;
  DateTime? _selectedDate;
  int _requestRevision = 0;

  @override
  DailyTasksState build() {
    _data = ref.read(dailyTasksDataProvider);
    final goalkeeper = ref.watch(currentGoalkeeperProvider);
    final date = _selectedDate ??= normalizeOccurrenceDate(DateTime.now());
    final revision = ++_requestRevision;
    if (goalkeeper != null) {
      Future<void>.microtask(
        () => _loadSnapshot(
          goalkeeperId: goalkeeper.id,
          date: date,
          revision: revision,
        ),
      );
    }
    return DailyTasksState(
      goalkeeperId: goalkeeper?.id,
      date: date,
      isLoading: goalkeeper != null,
    );
  }

  Future<void> _loadSnapshot({
    required int goalkeeperId,
    required DateTime date,
    required int revision,
  }) async {
    try {
      final results = await Future.wait<Object>([
        _data.tasksForDate(goalkeeperId, date),
        _data.stats(goalkeeperId, date),
      ]);
      if (!_isCurrentRequest(
        goalkeeperId: goalkeeperId,
        date: date,
        revision: revision,
      )) {
        return;
      }
      state = state.copyWith(
        goalkeeperId: goalkeeperId,
        tasks: results[0] as List<DailyTaskItem>,
        stats: results[1] as DailyTaskStats,
        isLoading: false,
        clearError: true,
      );
    } catch (error) {
      if (!_isCurrentRequest(
        goalkeeperId: goalkeeperId,
        date: date,
        revision: revision,
      )) {
        return;
      }
      state = state.copyWith(isLoading: false, error: error);
    }
  }

  bool _isCurrentRequest({
    required int goalkeeperId,
    required DateTime date,
    required int revision,
  }) =>
      revision == _requestRevision &&
      state.goalkeeperId == goalkeeperId &&
      state.date == date &&
      ref.read(currentGoalkeeperProvider)?.id == goalkeeperId;

  Future<void> refresh() async {
    final goalkeeperId = ref.read(currentGoalkeeperProvider)?.id;
    final date = state.date;
    final revision = ++_requestRevision;
    if (goalkeeperId == null) {
      state = DailyTasksState(date: date);
      return;
    }
    state = state.copyWith(
      goalkeeperId: goalkeeperId,
      isLoading: true,
      clearError: true,
    );
    await _loadSnapshot(
      goalkeeperId: goalkeeperId,
      date: date,
      revision: revision,
    );
  }

  Future<void> selectDate(DateTime date) async {
    final normalizedDate = normalizeOccurrenceDate(date);
    _selectedDate = normalizedDate;
    final goalkeeperId = ref.read(currentGoalkeeperProvider)?.id;
    final revision = ++_requestRevision;
    state = DailyTasksState(
      goalkeeperId: goalkeeperId,
      date: normalizedDate,
      isLoading: goalkeeperId != null,
    );
    if (goalkeeperId == null) return;
    await _loadSnapshot(
      goalkeeperId: goalkeeperId,
      date: normalizedDate,
      revision: revision,
    );
  }

  Future<void> createTask({
    required String title,
    String? description,
    bool enabled = true,
    int? expectedGoalkeeperId,
  }) async {
    final goalkeeperId = _requireCurrentGoalkeeper(expectedGoalkeeperId);
    await _data.createTask(
      goalkeeperId: goalkeeperId,
      title: title,
      description: description,
      enabled: enabled,
    );
    await _refreshIfCurrent(goalkeeperId);
  }

  Future<void> updateTask(
    int taskId, {
    required String title,
    String? description,
    bool? enabled,
    int? expectedGoalkeeperId,
  }) async {
    final goalkeeperId = _requireCurrentGoalkeeper(expectedGoalkeeperId);
    await _data.updateTask(
      goalkeeperId,
      taskId,
      title: title,
      description: description,
    );
    if (enabled != null) {
      await _data.setEnabled(goalkeeperId, taskId, enabled);
    }
    await _refreshIfCurrent(goalkeeperId);
  }

  Future<void> setEnabled(int taskId, bool enabled) async {
    final goalkeeperId = _requireCurrentGoalkeeper();
    await _data.setEnabled(goalkeeperId, taskId, enabled);
    await _refreshIfCurrent(goalkeeperId);
  }

  Future<void> deleteTask(int taskId, {int? expectedGoalkeeperId}) async {
    final goalkeeperId = _requireCurrentGoalkeeper(expectedGoalkeeperId);
    await _data.softDelete(goalkeeperId, taskId);
    await _refreshIfCurrent(goalkeeperId);
  }

  Future<void> setCompleted(int taskId, bool completed) async {
    final goalkeeperId = _requireCurrentGoalkeeper();
    if (completed) {
      await _data.complete(goalkeeperId, taskId, state.date);
    } else {
      await _data.uncomplete(goalkeeperId, taskId, state.date);
    }
    await _refreshIfCurrent(goalkeeperId);
  }

  int _requireCurrentGoalkeeper([int? expectedGoalkeeperId]) {
    final currentId = ref.read(currentGoalkeeperProvider)?.id;
    if (currentId == null ||
        state.goalkeeperId != currentId ||
        (expectedGoalkeeperId != null && expectedGoalkeeperId != currentId)) {
      throw const DailyTasksScopeException();
    }
    return currentId;
  }

  Future<void> _refreshIfCurrent(int goalkeeperId) async {
    if (ref.read(currentGoalkeeperProvider)?.id == goalkeeperId &&
        state.goalkeeperId == goalkeeperId) {
      await refresh();
    }
  }
}
