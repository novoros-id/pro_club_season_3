import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../l10n/app_localizations.dart';
import '../logic/daily_tasks_logic.dart';
import '../models/daily_task_stats.dart';

class DailyTasksScreen extends ConsumerWidget {
  const DailyTasksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dailyTasksControllerProvider);
    final controller = ref.read(dailyTasksControllerProvider.notifier);
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.dailyTasksTitle)),
      floatingActionButton: state.goalkeeperId == null
          ? null
          : FloatingActionButton(
              onPressed: () => context.push('/daily-tasks/new'),
              child: const Icon(Icons.add),
            ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.error != null
          ? _Message(text: l10n.dailyTasksLoadError)
          : state.goalkeeperId == null
          ? _Message(text: l10n.dailyTasksNoGoalkeeper)
          : RefreshIndicator(
              onRefresh: controller.refresh,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _StatsCard(stats: state.stats, l10n: l10n),
                  const SizedBox(height: 16),
                  if (state.tasks.isEmpty)
                    _Message(text: l10n.dailyTasksEmpty)
                  else
                    ...state.tasks.map(
                      (item) => Card(
                        child: ListTile(
                          leading: Checkbox(
                            value: item.isCompleted,
                            onChanged: (value) => controller.setCompleted(
                              item.task.id,
                              value ?? false,
                            ),
                          ),
                          title: Text(
                            item.task.title,
                            style: TextStyle(
                              decoration: item.isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                              color: item.isCompleted ? Colors.grey : null,
                            ),
                          ),
                          subtitle:
                              item.task.description == null ||
                                  item.task.description!.trim().isEmpty
                              ? null
                              : Text(item.task.description!),
                          trailing: IconButton(
                            icon: const Icon(Icons.more_vert),
                            onPressed: () => context.push(
                              '/daily-tasks/edit/${item.task.id}',
                              extra: item.task,
                            ),
                          ),
                          onTap: () => context.push(
                            '/daily-tasks/edit/${item.task.id}',
                            extra: item.task,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}

class _Message extends StatelessWidget {
  final String text;
  const _Message({required this.text});
  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Text(text, textAlign: TextAlign.center),
    ),
  );
}

class _StatsCard extends StatelessWidget {
  final DailyTaskStats stats;
  final AppLocalizations l10n;
  const _StatsCard({required this.stats, required this.l10n});
  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.dailyTasksStatistics,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text('${l10n.dailyTasksCompletedToday}: ${stats.completed}'),
          Text('${l10n.dailyTasksActiveTotal}: ${stats.total}'),
          Text(
            '${l10n.dailyTasksCompletionPercent}: ${stats.completionPercent.toStringAsFixed(0)}%',
          ),
          const SizedBox(height: 8),
          Text(l10n.dailyTasksLastSevenDays),
          if (stats.recentDays.isEmpty)
            Text(l10n.dailyTasksNoCompletedStatistics)
          else
            ...stats.recentDays.map((day) => _DayStat(day: day)),
        ],
      ),
    ),
  );
}

class _DayStat extends StatelessWidget {
  final DailyTaskDayStats day;
  const _DayStat({required this.day});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 3),
    child: Row(
      children: [
        SizedBox(width: 54, child: Text('${day.date.day}.${day.date.month}')),
        Expanded(
          child: LinearProgressIndicator(
            value: day.totalCount == 0
                ? 0
                : day.completedCount / day.totalCount,
          ),
        ),
        const SizedBox(width: 8),
        Text('${day.completedCount}/${day.totalCount}'),
      ],
    ),
  );
}
