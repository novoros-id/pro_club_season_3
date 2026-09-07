import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goalkeeper_trainer/features/daily_tasks/models/daily_task_stats.dart';
import 'package:goalkeeper_trainer/features/daily_tasks/ui/widgets/daily_progress_card.dart';
import 'package:goalkeeper_trainer/l10n/app_localizations.dart';

void main() {
  Widget buildCard({
    required int completed,
    required int total,
    required DateTime date,
  }) => MaterialApp(
    locale: const Locale('ru'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: DailyProgressCard(
          stats: DailyTaskStats(
            totalTasksToday: total,
            completedToday: completed,
            recentDays: const [],
          ),
          goalkeeperId: 7,
          selectedDate: date,
        ),
      ),
    ),
  );

  testWidgets('5/8 shows rounded actual progress and ten segments', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      buildCard(completed: 5, total: 8, date: DateTime.now()),
    );

    expect(find.text('63% выполнено сегодня'), findsOneWidget);
    for (var index = 0; index < 10; index++) {
      expect(find.byKey(Key('dailyProgressSegment$index')), findsOneWidget);
    }
    final partialSegment = tester.widget<FractionallySizedBox>(
      find.byKey(const Key('dailyProgressSegmentFill6')),
    );
    expect(partialSegment.widthFactor, 0.25);
    expect(
      tester.widget<Text>(find.byKey(const Key('dailyProgressMessage'))).data,
      isIn(const [
        'Реши, каким вратарём хочешь быть — и вперёд.',
        'Экватор позади — характер проверяется здесь.',
        'Видно, кто пришёл работать. Продолжай.',
      ]),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('noTasks shows a neutral empty state', (tester) async {
    await tester.pumpWidget(
      buildCard(completed: 0, total: 0, date: DateTime.now()),
    );

    expect(find.text('0% выполнено сегодня'), findsOneWidget);
    expect(find.text('Нет активных задач на этот день'), findsOneWidget);
    expect(find.byKey(const Key('dailyProgressMessage')), findsNothing);
    expect(find.byKey(const Key('dailyProgressCompletedState')), findsNothing);
  });

  testWidgets('8/8 shows completed state for another date', (tester) async {
    await tester.pumpWidget(
      buildCard(completed: 8, total: 8, date: DateTime(2025, 1, 2)),
    );

    expect(find.text('100% выполнено за день'), findsOneWidget);
    expect(find.text('день закрыт на ноль'), findsOneWidget);
    expect(
      tester.widget<Text>(find.byKey(const Key('dailyProgressMessage'))).data,
      isIn(const [
        'Сухарь! Красавец, повтори завтра.',
        'Сто процентов — вот это характер. Так держать!',
        'Все шайбы отбиты, все задачи взяты.',
      ]),
    );
    for (var index = 0; index < 10; index++) {
      final segment = tester.widget<FractionallySizedBox>(
        find.byKey(Key('dailyProgressSegmentFill$index')),
      );
      expect(segment.widthFactor, 1);
    }
  });
}
