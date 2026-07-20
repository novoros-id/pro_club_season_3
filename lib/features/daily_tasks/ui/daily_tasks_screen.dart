import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../l10n/app_localizations.dart';
import '../logic/daily_tasks_logic.dart';
import '../models/daily_task_stats.dart';
import 'daily_tasks_styles.dart';

class DailyTasksScreen extends ConsumerWidget {
  const DailyTasksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dailyTasksControllerProvider);
    final controller = ref.read(dailyTasksControllerProvider.notifier);
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: DailyTasksStyles.dark,
        elevation: 0,
        title: Text(
          l10n.dailyTasksTitle.toUpperCase(),
          style: DailyTasksStyles.screenTitle,
        ),
      ),
      floatingActionButton: state.goalkeeperId == null
          ? null
          : FloatingActionButton(
              onPressed: () => context.push('/daily-tasks/new'),
              backgroundColor: DailyTasksStyles.accent,
              foregroundColor: DailyTasksStyles.dark,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Icon(Icons.add),
            ),
      body: state.isLoading
          ? const Center(
              child: CircularProgressIndicator(color: DailyTasksStyles.accent),
            )
          : state.error != null
          ? _Message(text: l10n.dailyTasksLoadError)
          : state.goalkeeperId == null
          ? _Message(text: l10n.dailyTasksNoGoalkeeper)
          : RefreshIndicator(
              color: DailyTasksStyles.dark,
              backgroundColor: DailyTasksStyles.accent,
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
                      (item) => Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: item.isCompleted
                              ? DailyTasksStyles.fieldBackground
                              : Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: DailyTasksStyles.accent,
                            width: 1.2,
                          ),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            leading: Checkbox(
                              value: item.isCompleted,
                              fillColor: WidgetStateProperty.resolveWith(
                                (states) =>
                                    states.contains(WidgetState.selected)
                                    ? DailyTasksStyles.accent
                                    : Colors.transparent,
                              ),
                              checkColor: DailyTasksStyles.dark,
                              side: const BorderSide(
                                color: DailyTasksStyles.dark,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              onChanged: (value) => controller.setCompleted(
                                item.task.id,
                                value ?? false,
                              ),
                            ),
                            title: Text(
                              item.task.title,
                              style: TextStyle(
                                fontFamily: 'Lato',
                                fontSize: 16,
                                color: item.isCompleted
                                    ? DailyTasksStyles.secondaryText
                                    : DailyTasksStyles.dark,
                                decoration: item.isCompleted
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                            subtitle:
                                item.task.description == null ||
                                    item.task.description!.trim().isEmpty
                                ? null
                                : Text(
                                    item.task.description!,
                                    style: DailyTasksStyles.helper,
                                  ),
                            trailing: IconButton(
                              icon: const Icon(Icons.more_vert),
                              color: DailyTasksStyles.dark,
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
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: DailyTasksStyles.body,
      ),
    ),
  );
}

class _StatsCard extends StatelessWidget {
  final DailyTaskStats stats;
  final AppLocalizations l10n;
  const _StatsCard({required this.stats, required this.l10n});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: DailyTasksStyles.fieldBackground,
      borderRadius: BorderRadius.circular(15),
      border: Border.all(color: DailyTasksStyles.accent, width: 1.2),
    ),
    child: Padding(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.dailyTasksStatistics.toUpperCase(),
            style: DailyTasksStyles.screenTitle.copyWith(fontSize: 16),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 18,
            runSpacing: 8,
            children: [
              _Metric(
                label: l10n.dailyTasksCompletedToday,
                value: '${stats.completed}',
              ),
              _Metric(
                label: l10n.dailyTasksActiveTotal,
                value: '${stats.total}',
              ),
              _Metric(
                label: l10n.dailyTasksCompletionPercent,
                value: '${stats.completionPercent.toStringAsFixed(0)}%',
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(l10n.dailyTasksLastSevenDays, style: DailyTasksStyles.helper),
          if (stats.recentDays.isEmpty)
            Text(l10n.dailyTasksNoCompletedStatistics)
          else
            ...stats.recentDays.map((day) => _DayStat(day: day)),
        ],
      ),
    ),
  );
}

class _Metric extends StatelessWidget {
  final String label;
  final String value;
  const _Metric({required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(value, style: DailyTasksStyles.screenTitle.copyWith(fontSize: 20)),
      Text(label, style: DailyTasksStyles.helper),
    ],
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
        SizedBox(
          width: 54,
          child: Text(
            '${day.date.day}.${day.date.month}',
            style: DailyTasksStyles.helper,
          ),
        ),
        Expanded(
          child: LinearProgressIndicator(
            minHeight: 5,
            backgroundColor: Colors.white,
            color: DailyTasksStyles.accent,
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
