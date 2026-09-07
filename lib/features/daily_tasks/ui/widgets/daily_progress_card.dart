import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../logic/daily_progress_display.dart';
import '../../logic/daily_progress_stage.dart';
import '../../models/daily_task_stats.dart';
import '../daily_tasks_styles.dart';

class DailyProgressCard extends StatelessWidget {
  final DailyTaskStats stats;
  final int goalkeeperId;
  final DateTime selectedDate;

  const DailyProgressCard({
    super.key,
    required this.stats,
    required this.goalkeeperId,
    required this.selectedDate,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final stage = resolveDailyProgressStage(
      completedCount: stats.completedToday,
      totalCount: stats.totalTasksToday,
    );
    final progress = (stats.completionPercentToday / 100).clamp(0.0, 1.0);
    final displayedPercent = stats.completionPercentToday.round().clamp(0, 100);
    final progressText = _isSameCalendarDay(selectedDate, DateTime.now())
        ? l10n.dailyTasksProgressCompletedToday(displayedPercent)
        : l10n.dailyTasksProgressCompletedForDay(displayedPercent);
    final messages = _messagesForStage(l10n, stage);
    final message = messages == null
        ? l10n.dailyTasksProgressNoTasks
        : messages[resolveDailyProgressMessageIndex(
            goalkeeperId: goalkeeperId,
            date: selectedDate,
            stage: stage,
          )];

    return Container(
      key: const Key('dailyProgressCard'),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: DailyTasksStyles.fieldBackground,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: DailyTasksStyles.accent, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.dailyTasksProgressTitle.toUpperCase(),
            style: DailyTasksStyles.screenTitle.copyWith(fontSize: 16),
          ),
          const SizedBox(height: 10),
          Text(
            progressText,
            key: const Key('dailyProgressPercent'),
            style: DailyTasksStyles.screenTitle.copyWith(fontSize: 20),
          ),
          const SizedBox(height: 12),
          _SegmentedProgressBar(progress: progress),
          const SizedBox(height: 12),
          Text(
            message,
            key: stage == DailyProgressStage.noTasks
                ? const Key('dailyProgressEmptyState')
                : const Key('dailyProgressMessage'),
            style: DailyTasksStyles.body,
          ),
          if (stage == DailyProgressStage.percent100) ...[
            const SizedBox(height: 4),
            Text(
              l10n.dailyTasksProgressCompletedState,
              key: const Key('dailyProgressCompletedState'),
              style: DailyTasksStyles.helper,
            ),
          ],
        ],
      ),
    );
  }
}

class _SegmentedProgressBar extends StatelessWidget {
  final double progress;

  const _SegmentedProgressBar({required this.progress});

  @override
  Widget build(BuildContext context) => Row(
    key: const Key('dailyProgressBar'),
    children: List.generate(10, (index) {
      final fill = dailyProgressSegmentFill(
        progress: progress,
        segmentIndex: index,
      );
      return Expanded(
        child: Padding(
          padding: EdgeInsets.only(right: index == 9 ? 0 : 4),
          child: ClipRRect(
            key: Key('dailyProgressSegment$index'),
            borderRadius: BorderRadius.circular(4),
            child: SizedBox(
              height: 12,
              child: ColoredBox(
                color: Colors.white,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: FractionallySizedBox(
                    key: Key('dailyProgressSegmentFill$index'),
                    widthFactor: fill,
                    heightFactor: 1,
                    child: const ColoredBox(color: DailyTasksStyles.accent),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }),
  );
}

List<String>? _messagesForStage(
  AppLocalizations l10n,
  DailyProgressStage stage,
) => switch (stage) {
  DailyProgressStage.noTasks => null,
  DailyProgressStage.percent0 => [
    l10n.dailyTasksProgress0Message1,
    l10n.dailyTasksProgress0Message2,
    l10n.dailyTasksProgress0Message3,
  ],
  DailyProgressStage.percent20 => [
    l10n.dailyTasksProgress20Message1,
    l10n.dailyTasksProgress20Message2,
    l10n.dailyTasksProgress20Message3,
  ],
  DailyProgressStage.percent40 => [
    l10n.dailyTasksProgress40Message1,
    l10n.dailyTasksProgress40Message2,
    l10n.dailyTasksProgress40Message3,
  ],
  DailyProgressStage.percent60 => [
    l10n.dailyTasksProgress60Message1,
    l10n.dailyTasksProgress60Message2,
    l10n.dailyTasksProgress60Message3,
  ],
  DailyProgressStage.percent80 => [
    l10n.dailyTasksProgress80Message1,
    l10n.dailyTasksProgress80Message2,
    l10n.dailyTasksProgress80Message3,
  ],
  DailyProgressStage.percent100 => [
    l10n.dailyTasksProgress100Message1,
    l10n.dailyTasksProgress100Message2,
    l10n.dailyTasksProgress100Message3,
  ],
};

bool _isSameCalendarDay(DateTime first, DateTime second) =>
    first.year == second.year &&
    first.month == second.month &&
    first.day == second.day;
