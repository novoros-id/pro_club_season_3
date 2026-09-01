import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../l10n/app_localizations.dart';
import '../../registration/logic/goalkeepers_controller.dart';
import '../logic/daily_tasks_logic.dart';
import '../models/built_in_daily_task.dart';
import '../models/daily_task_stats.dart';
import 'daily_tasks_styles.dart';

class DailyTasksScreen extends ConsumerWidget {
  const DailyTasksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dailyTasksControllerProvider);
    final goalkeeper = ref.watch(currentGoalkeeperProvider);
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
      body: Column(
        children: [
          _DateSelector(
            date: state.date,
            onDateSelected: controller.selectDate,
          ),
          if (goalkeeper != null)
            _GoalkeeperHeader(
              name: '${goalkeeper.firstName} ${goalkeeper.lastName}',
            ),
          Expanded(
            child: state.isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: DailyTasksStyles.accent,
                    ),
                  )
                : state.error != null
                ? _Message(text: l10n.dailyTasksLoadError)
                : state.goalkeeperId == null
                ? _NoGoalkeeper(l10n: l10n)
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
                                    onChanged: (value) =>
                                        controller.setCompleted(
                                          item.task.id,
                                          value ?? false,
                                        ),
                                  ),
                                  title: Text(
                                    item.task.isSystem
                                        ? builtInDailyTaskTitle(
                                            l10n,
                                            item.task.systemKey,
                                          )
                                        : item.task.title,
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
                                  trailing: item.task.isSystem
                                      ? null
                                      : IconButton(
                                          icon: const Icon(Icons.more_vert),
                                          color: DailyTasksStyles.dark,
                                          onPressed: () => context.push(
                                            '/daily-tasks/edit/${item.task.id}',
                                            extra: item.task,
                                          ),
                                        ),
                                  onTap: item.task.isSystem
                                      ? null
                                      : () => context.push(
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
          ),
        ],
      ),
    );
  }
}

class _DateSelector extends StatelessWidget {
  final DateTime date;
  final Future<void> Function(DateTime date) onDateSelected;

  const _DateSelector({required this.date, required this.onDateSelected});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd.MM.yyyy');
    final dayFormat = DateFormat(
      'EEEE',
      Localizations.localeOf(context).toString(),
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: date,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2100),
                );
                if (picked != null && picked != date) {
                  await onDateSelected(picked);
                }
              },
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                      '${dayFormat.format(date)}, ${dateFormat.format(date)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Unbounded',
                        fontSize: 16,
                        color: DailyTasksStyles.secondaryText,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.calendar_today,
                    color: DailyTasksStyles.secondaryText,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GoalkeeperHeader extends StatelessWidget {
  final String name;
  const _GoalkeeperHeader({required this.name});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
    child: Row(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: DailyTasksStyles.accent.withValues(alpha: 0.25),
          child: Text(
            name
                .split(' ')
                .where((part) => part.isNotEmpty)
                .take(2)
                .map((part) => part[0])
                .join(),
            style: DailyTasksStyles.body,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            AppLocalizations.of(context)!.dailyTasksForGoalkeeper(name),
            style: DailyTasksStyles.body,
          ),
        ),
      ],
    ),
  );
}

class _NoGoalkeeper extends StatelessWidget {
  final AppLocalizations l10n;
  const _NoGoalkeeper({required this.l10n});

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            l10n.dailyTasksNoGoalkeeper,
            textAlign: TextAlign.center,
            style: DailyTasksStyles.body,
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () => context.push('/registration'),
            style: DailyTasksStyles.primaryButton,
            child: Text(l10n.dailyTasksChooseGoalkeeper),
          ),
        ],
      ),
    ),
  );
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Metric(
                label: l10n.dailyTasksCompletedTodayLabel,
                value: '${stats.completedToday}',
              ),
              _Metric(
                label: l10n.dailyTasksActiveTasksLabel,
                value: '${stats.remainingActiveTasksToday}',
              ),
              _Metric(
                label: l10n.dailyTasksCompletionPercentLabel,
                value: '${stats.completionPercentToday.toStringAsFixed(0)}%',
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            l10n.dailyTasksRecentCompletedDays,
            style: DailyTasksStyles.helper,
          ),
          if (stats.recentDays.isEmpty)
            Text(l10n.dailyTasksNoCompletedStatistics)
          else
            LayoutBuilder(
              builder: (context, constraints) {
                const gap = 8.0;
                final adaptiveWidth = (constraints.maxWidth - gap * 2) / 3;
                final cardWidth = adaptiveWidth.clamp(64.0, 88.0).toDouble();
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(stats.recentDays.length, (index) {
                      return Padding(
                        padding: EdgeInsets.only(
                          right: index == stats.recentDays.length - 1 ? 0 : gap,
                        ),
                        child: _DayStat(
                          day: stats.recentDays[index],
                          width: cardWidth,
                        ),
                      );
                    }),
                  ),
                );
              },
            ),
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
  Widget build(BuildContext context) => Expanded(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value, style: DailyTasksStyles.screenTitle.copyWith(fontSize: 20)),
        Text(
          label,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: DailyTasksStyles.helper,
        ),
      ],
    ),
  );
}

class _DayStat extends StatelessWidget {
  final DailyTaskDayStats day;
  final double width;
  const _DayStat({required this.day, required this.width});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 8),
    child: SizedBox(
      width: width,
      height: width,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: DailyTasksStyles.accent, width: 1.2),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      '${day.date.day}.${day.date.month}',
                      textAlign: TextAlign.center,
                      style: DailyTasksStyles.screenTitle.copyWith(
                        fontSize: (width * 0.2).clamp(14.0, 18.0),
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      '${day.completedCount}/${day.totalCount}',
                      textAlign: TextAlign.center,
                      style: DailyTasksStyles.screenTitle.copyWith(
                        fontSize: (width * 0.2).clamp(14.0, 18.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 4,
              right: 4,
              top: width / 2,
              child: const Divider(
                height: 1,
                thickness: 1,
                color: DailyTasksStyles.accent,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
